---
title: "Docker/Kubernetes 実践コンテナ開発入門@26日目"
description:
slug: "docker-kubernetes-26days"
date: 2020-11-09T15:54:12+0000
lastmod: 2020-11-09T15:54:12+0000
image:
math:
draft: false
---

[Docker/Kubernetes 実践コンテナ開発入門：書籍案内｜技術評論社](https://gihyo.jp/book/2018/978-4-297-10033-9)

前回は、k8s のリソースの Service について学習しました。
Service は基本的には Pod→Pod への経路を指定するためのものでした。

今回は Ingress についてやっていきます。

## 5.10 Ingress

- NodePort は L4 層レベルまでのため、HTTP/HTTPS のように L7 層レベルの制御ができない
  - たまたま見つけたけど、層については下記の記事が参考になる
  - [『Docker/Kubernetes 実践コンテナ開発入門』輪読会 \#5 \- Speaker Deck](https://speakerdeck.com/nagaakihoshi/kubernetes-shi-jian-kontenakai-fa-ru-men-lun-du-hui-number-5?slide=18)
- これを解決するのが Ingress
- 素のローカル k8s 環境では使えない。

- そのため、nginx_ingress_controller をデプロイします。

```
$ kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/nginx-0.16.2/deploy/mandatory.yaml
namespace/ingress-nginx created
service/default-http-backend created
configmap/nginx-configuration created
configmap/tcp-services created
configmap/udp-services created
serviceaccount/nginx-ingress-serviceaccount created
clusterrole.rbac.authorization.k8s.io/nginx-ingress-clusterrole created
role.rbac.authorization.k8s.io/nginx-ingress-role created
rolebinding.rbac.authorization.k8s.io/nginx-ingress-role-nisa-binding created
clusterrolebinding.rbac.authorization.k8s.io/nginx-ingress-clusterrole-nisa-binding created
unable to recognize "https://raw.githubusercontent.com/kubernetes/ingress-nginx/nginx-0.16.2/deploy/mandatory.yaml": no matches for kind "Deployment" in version "extensions/v1beta1"
unable to recognize "https://raw.githubusercontent.com/kubernetes/ingress-nginx/nginx-0.16.2/deploy/mandatory.yaml": no matches for kind "Deployment" in version "extensions/v1beta1"

$ kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/nginx-0.16.2/deploy/provider/cloud-generic.yaml
service/ingress-nginx created
```

- テキストが古いためかエラーが出ている。

  - no matches for kind "Deployment" in version "extensions/v1beta1"

- k8s のバージョンは 1.18.8（Docker の Settings の k8s の項目から確認できる）

- 1.18.8 が対応する API を確認
  - `apps`を含む apiVersion のみが Deployment に対して正しい
  - `extensions`は Deployment をサポートしていない
  - [kubernetes — バージョン「extensions / v1beta1」の種類「Deployment」に一致するものはありません](https://www.it-swarm-ja.tech/ja/kubernetes/%E3%83%90%E3%83%BC%E3%82%B8%E3%83%A7%E3%83%B3%E3%80%8Cextensions-v1beta1%E3%80%8D%E3%81%AE%E7%A8%AE%E9%A1%9E%E3%80%8Cdeployment%E3%80%8D%E3%81%AB%E4%B8%80%E8%87%B4%E3%81%99%E3%82%8B%E3%82%82%E3%81%AE%E3%81%AF%E3%81%82%E3%82%8A%E3%81%BE%E3%81%9B%E3%82%93/813764018/)

```
$  kubectl api-resources | grep deployment
deployments                       deploy       apps                           true         Deployment
```

- 公式を見ながらやる方法もあるけど、、いったんテキストの yaml を書き換える方法でやってみる。

  - 公式
    - [マスターの ingress\-nginx / index\.md・kubernetes / ingress\-nginx](https://github.com/kubernetes/ingress-nginx/blob/master/docs/deploy/index.md)

- mandatory.yaml をローカルに落として、extensions/v1beta1 を apps/v1 に置換して再実行
- いけたー！！！

```
$ kubectl apply -f mandatory.yaml
namespace/ingress-nginx created
deployment.apps/default-http-backend created
service/default-http-backend created
configmap/nginx-configuration created
configmap/tcp-services created
configmap/udp-services created
serviceaccount/nginx-ingress-serviceaccount created
clusterrole.rbac.authorization.k8s.io/nginx-ingress-clusterrole created
role.rbac.authorization.k8s.io/nginx-ingress-role created
rolebinding.rbac.authorization.k8s.io/nginx-ingress-role-nisa-binding created
clusterrolebinding.rbac.authorization.k8s.io/nginx-ingress-clusterrole-nisa-binding created
deployment.apps/nginx-ingress-controller created
```

- さっきは Pod が起動してなかったけど、ちゃんと Pod も起動してくれた
- これで Ingress リソースを利用する準備が整った

```
$ kubectl -n ingress-nginx get service,pod
NAME                           TYPE           CLUSTER-IP       EXTERNAL-IP   PORT(S)                      AGE
service/default-http-backend   ClusterIP      10.108.154.236   <none>        80/TCP                       93s
service/ingress-nginx          LoadBalancer   10.104.144.30    localhost     80:30719/TCP,443:31795/TCP   11s

NAME                                           READY   STATUS    RESTARTS   AGE
pod/default-http-backend-57fb4c77b4-zxq6b      1/1     Running   0          93s
pod/nginx-ingress-controller-7bfbcc484-ql2m8   1/1     Running   0          93s
```

### 5.10.1 Ingress を通じたアクセス

- Ingress を通して Service にアクセス

- simple-service.yaml
  - spec.type が未指定のときは ClusterIP Service で作成される

```
apiVersion: v1
kind: Service
metadata:
  name: echo
spec:
  selector:
    app: echo
  ports:
    - name: http
      port: 80
```

- マニフェストファイルの変更を反映

```
$ kubectl apply -f simple-service.yaml
The Service "echo" is invalid: spec.ports[0].nodePort: Forbidden: may not be used when `type` is 'ClusterIP'
```

- エラーが出るので一旦 Service 削除

```
$ kubectl delete -f simple-service.yaml
service "echo" deleted
```

- 再度実行

```
$ kubectl apply -f simple-service.yaml
service/echo created
```

- simple-ingress.yaml を作成・反映

```
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: echo
spec:
  rules:
  - host: ch05.gihyo.local
    http:
      paths:
      - path: /
        backend:
          serviceName: echo
          servicePort: 80
```

```
$ kubectl apply -f simple-ingress.yaml
ingress.extensions/echo created
```

```
$ kubectl get ingress
NAME   CLASS    HOSTS              ADDRESS     PORTS   AGE
echo   <none>   ch05.gihyo.local   localhost   80      42s
```

- Ingeress の spec.rules.host 属性に合致するのでバックエンドの Service にリクエストが委譲されるようだ。

```
$ curl http://localhost -H 'Host: ch05.gihyo.local'
Hello Docker!!
```

- 他にも Ingress の層では様々な制御ができる
- simple-ingress.yaml に次のような変更を加える

```
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: echo
  annotations:
    nginx.ingress.kubernetes.io/server-snippet: |
      set $agentflag 0;

      if ($http_user_agent ~* "(Mobile)" ){
        set $agentflag 1;
      }

      if ( $agentflag = 1 ) {
        return 301 http://gihyo.jp/;
      }

spec:
  rules:
  - host: ch05.gihyo.local
    http:
      paths:
      - path: /
        backend:
          serviceName: echo
          servicePort: 80
```

- 変更を反映する

```
$ kubectl apply -f simple-ingress.yaml
ingress.extensions/echo configured
```

- モバイルに偽装してリクエストを飛ばすとリダイレクトされることがわかる。

```
$ curl http://localhost -H 'Host: ch05.gihyo.local' -H 'User-Agent: Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1'
<html>
<head><title>301 Moved Permanently</title></head>
<body bgcolor="white">
<center><h1>301 Moved Permanently</h1></center>
<hr><center>nginx/1.13.12</center>
</body>$ curl http://localhost -H 'Host: ch05.gihyo.local' -H 'User-Agent: Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1'
<html>
<head><title>301 Moved Permanently</title></head>
<body bgcolor="white">
<center><h1>301 Moved Permanently</h1></center>
<hr><center>nginx/1.13.12</center>
</body>
```

- バックエンドの Web サーバやアプリケーションがこのような制御から解放される
- Ingress はパブリッククラウドにおいてはそのプラットフォームの L7 ロードバランサーを利用可能
  - GCP
    - Cloud Load Balancing
  - AWS
    - Application Load Balancer

### コラム freshpod でイメージの更新を検知し，Pod を自動更新する

- freshpod
  - イメージの更新を検知し、Pod を自動更新する
  - webpacker の dev-server とかに近いイメージを持った！

### コラム kube-prompt

- kube-prompt
  - macOS/Linux 向け
  - kubectl のコマンドや、リソース名の候補を補完してくれるツール

### コラム Kubernetes API

- k8s のリソースの作成・更新・削除は k8s クラスタにデプロイされている API によって実行される
- apiVersion はリソースの操作に利用する API の種別
- k8s クラスタで利用できる API の確認方法

```
$ kubectl api-versions
```

- 各種リソースがどの API に対応しているかはリポジトリを見る。
  - https://github.com/kubernetes/api
- v1
  - Service、Pod
- apps/v1
  - Deployment
- extenxionx/v1beta1
  - Ingress

## 今日の学び

- Ingress は外部からの HTTP/HTTPS リクエストを受けることができ、Service に委譲することができる。
- 設定次第では、Web サーバやアプリケーション層の L7 層の役割を担うことができる。
- 最初はテキスト通りにうまくいかずどうなるかと思ったけど、なんとか動いてくれてよかった！
