---
title: "Docker/Kubernetes 実践コンテナ開発入門@25日目"
description:
slug: "docker-kubernetes-25days"
date: 2020-11-08T15:52:47+0000
lastmod: 2020-11-08T15:52:47+0000
image:
math:
draft: false
---

[Docker/Kubernetes 実践コンテナ開発入門：書籍案内｜技術評論社](https://gihyo.jp/book/2018/978-4-297-10033-9)

昨日は ReplicaSet で Pod の複製とその上位の Deployment で ReplicaSet のバージョン管理やロールバックを行いました。

今回は Service についてやっていきます。

## 5.9 Service

- Service とは、Pod の集合にアクセスするための経路を定義するリソース
- Service のターゲットとなる一連の Pod は、Service で定義するラベルセレクタによって決定

- simple-replicaset-with-label.yaml

```
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: echo-spring
  labels:
    app: echo
    release: spring
spec:
  replicas: 1
  selector:
    matchLabels:
      app: echo
      release: spring
  template:
    metadata:
      labels:
        app: echo
        release: spring
    spec:
      containers:
      - name: nginx
        image: gihyodocker/nginx:latest
        env:
        - name: BACKEND_HOST
          value: localhost:8080
        ports:
        - containerPort: 80
      - name: echo
        image: gihyodocker/echo:latest
        ports:
        - containerPort: 8080

---
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: echo-summer
  labels:
    app: echo
    release: summer
spec:
  replicas: 2
  selector:
    matchLabels:
      app: echo
      release: summer
  template:
    metadata:
      labels:
        app: echo
        release: summer
    spec:
      containers:
      - name: nginx
        image: gihyodocker/nginx:latest
        env:
        - name: BACKEND_HOST
          value: localhost:8080
        ports:
        - containerPort: 80
      - name: echo
        image: gihyodocker/echo:latest
        ports:
        - containerPort: 8080
```

- マニフェストファイルを k8s クラスタに反映

```
$ kubectl apply -f simple-replicaset-with-label.yaml
replicaset.apps/echo-spring created
replicaset.apps/echo-summer created
```

- 作成された Pod を確認

```
$ kubectl get pod -l app=echo -l release=spring
NAME                READY   STATUS    RESTARTS   AGE
echo-spring-5dprx   2/2     Running   0          55s
```

```
$ kubectl get pod -l app=echo -l release=summer
NAME                READY   STATUS    RESTARTS   AGE
echo-summer-2xj8q   2/2     Running   0          2m47s
echo-summer-vjv9j   2/2     Running   0          2m47s
```

- release=summer を持つ Pod だけにアクセスできる Service を作る

- simple-service.yaml
  - spec.selector 属性には、Service のターゲットとなる Pod が持つラベルを指定
    - 対象の Pod があった場合は Service 経由でトラフィックが流れるようになる => Rails でいうルーティングに近いものがある

```
apiVersion: v1
kind: Service
metadata:
  name: echo
spec:
  selector:
    app: echo
    release: summer
  ports:
    - name: http
      port: 80
```

- k8s クラスタに反映

```
$ kubectl apply -f simple-service.yaml
service/echo created
```

- 作成された Service を確認

```
$  kubectl get svc echo
NAME   TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)   AGE
echo   ClusterIP   10.111.36.1   <none>        80/TCP    20s
```

- 実際に、release=summer を持つ Pod だけにトラフィックが流れる確認
- 基本的に Service は k8s クラスタの中からしかアクセスできない => 外部からはアクセスできないということか

- k8s クラスタ内にデバッグコンテナをデプロイ → デバッグコンテナから curl コマンドで HTTP リクエストを送る

```
$ kubectl run -i --rm --tty debug --image=gihyodocker/fundamental:0.1.0 --restart=Never -- bash -il
If you don't see a command prompt, try pressing enter.
debug:/# curl http://echo/ # ← HTTPリクエストを送信
Hello Docker!!debug:/#
```

- 各 Pod のログを確認すると、summer のラベルを持つ Pod のみログが確認できる

```
$ kubectl logs -f echo-summer-2xj8q -c echo
2020/11/08 14:35:35 start server

$ kubectl logs -f echo-summer-vjv9j -c echo
2020/11/08 14:35:32 start server
2020/11/08 14:48:14 received request # ← summerのラベルを持つPodのみログが出力されている

$ kubectl logs -f echo-spring-5dprx -c echo
2020/11/08 14:35:28 start server
```

### コラム Service の名前解決

- k8s クラスタ内の DNS では、Service を`Service名.Namespace名.svc.local`で名前解決できる

```
$ curl http://echo.default.svc.local # 基本はこう

$ curl http://echo.default # svc.lodalは省略可能

$ curl http://echo # さらに同一Namespace内であればNamespace名も省略可能
```

### 5.9.1 ClusterIP Service

- Sevice には様々な種類がある。
- デフォルトは ClusterIP Service
- K8s クラスタ上の内部 IP アドレスに Service を公開できる
- Pod から別の Pod へのアクセスが Service を介してできる => ただし、外からはアクセスできない

### 5.9.2 NodePort Service

- クラスタ外からアクセスできる Service
- 各ノード上から Service ポートへ接続するためのグローバルなポートを開ける

```
apiVersion: v1
kind: Service
metadata:
  name: echo
spec:
  type: NodePort
  selector:
    app: echo
  ports:
    - name: http
      port: 80
```

- Service を作成

```
$ kubectl apply -f simple-node-port-service.yaml
service/echo configured
```

- 作成した Service を確認
  - 80:30026/TCP と表示されているようにノードの 30026 ポートから Service にアクセスできる

```
$ kubectl get svc echo
NAME   TYPE       CLUSTER-IP    EXTERNAL-IP   PORT(S)        AGE
echo   NodePort   10.111.36.1   <none>        80:30026/TCP   25mj
```

- 次のようにhttp://127.0.0.1:30026でアクセスできる

```
$ curl http://127.0.0.1:30026
Hello Docker!!
```

### 5.9.3 LoadBalancer Service

- ローカル k8s 環境では利用できない Service
- 主に各クラウドプラットフォームで提供されているロードバランサーと連携するためのもの
  - GCP
    - Cloud Load Balancing が対応
  - AWS
    - Elastic Load Balancing が対応

### 5.9.4 ExternalName Service

- selector も port 定義もない特殊な Service
- k8s クラスタ内から外部のホストを解決するためのエイリアスを提供

- 次の例では、gihyo.jp を gihyou で名前解決できる

```
apiVersion: v1
kind: Service
metadata:
  name: gihyo
spec:
  type: ExternalName
  externalName: gihyo.jp
```

## 今日の学び

- Service は、アクセスする先の Pod を指定するためのリソース
  - spec.selector 属性で、Service のターゲットとなる Pod が持つラベルを指定
- Service には様々な種類がある。
  - ClusterIP Service
    - Pod → Service → Pod ※外からはアクセス不可
  - NodePort Service
    - 外 → Serveic → Pod
  - LoadBalancer Service
    - ロードバランサーと連携
  - ExternalName Service
    - 名前解決するための Service
