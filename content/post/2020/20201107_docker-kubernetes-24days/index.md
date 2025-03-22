---
title: "Docker/Kubernetes 実践コンテナ開発入門@24日目"
description:
slug: "docker-kubernetes-24days"
date: 2020-11-07T15:44:53+0000
lastmod: 2020-11-07T15:44:53+0000
image:
math:
draft: false
---

[Docker/Kubernetes 実践コンテナ開発入門：書籍案内｜技術評論社](https://gihyo.jp/book/2018/978-4-297-10033-9)

昨日の記事が日付をまたいだ後に作ったため、日付的に同じですが今日は 24 日目になります。

今日は Pod の章の続きからです。

## 5.7 ReplicaSet

- Pod を定義したマニフェストファイルからは 1 つの Pod しか作成できない
- 同じ Pod を複数生成・管理する場合は ReplicaSet を利用する => Pod でレプリカ数を設定できればよさそうだけど、そうじゃないみたい。

- simple-replicaset.yaml
  - ReplicaSet を定義したマニフェストファイル

```
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: echo
  labels:
    app: echo
spec:
  replicas: 3
  selector:
    matchLabels:
      app: echo
  template: # template以下はPodリソースにおける定義と同じ
    metadata:
      labels:
        app: echo
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

- replicas
  - 作成する Pod 数を設定
- template

  - Pod 定義と同じもの

- ReplicaSet がこの定義をもとに replicas 数だけ Pod の複製を行う

- ReplicaSet を反映

```
$ kubectl apply -f simple-replicaset.yaml
replicaset.apps/echo created
```

- Pod の一覧を取得
  - Pod が 3 つ作成されたことが確認できる
  - 同一の Pod 名が複製されるため、ランダムな識別子がサフィックスに付与されている

```
$ kubectl get pod
NAME         READY   STATUS    RESTARTS   AGE
echo-hgdd6   2/2     Running   0          112s
echo-k2bgk   2/2     Running   0          112s
echo-rmfvn   2/2     Running   0          112s
```

- ReplicaSet を操作して Pod の数を減らすと、減らした分の Pod は削除される
- 削除された Pod は復元できない => ステートレスな Pod に向いている

- ReplicaSet と関連する Pod を削除

```
$ kubectl delete -f simple-replicaset.yaml
replicaset.apps "echo" deleted
```

## 5.8 Deployment

- Deployment

  - ReplicaSet を管理・操作するためのリソース
  - ReplicaSet より上位のリソース

- simple-deployment.yaml

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: echo
  labels:
    app: echo
spec:
  replicas: 3
  selector:
    matchLabels:
      app: echo
  template: # template以下はPodリソースにおけるspec定義と同じ
    metadata:
      labels:
        app: echo
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

- Deployment の定義は ReplicaSet とほぼ差がない(差分は kind の設定のみ)
- 違いは Deployment が ReplicaSet の世代管理を可能にする点

- kubectl のコマンドを記録するために--record オプションをつける

```
$ kubectl apply -f simple-deployment.yaml --record
deployment.apps/echo created
```

- 各リソース(pod、replicaset、deployment)を確認する

```
$ kubectl get pod,replicaset,deployment --selector app=echo
NAME                        READY   STATUS    RESTARTS   AGE
pod/echo-6968d87679-pxpbt   2/2     Running   0          41s
pod/echo-6968d87679-t5t2j   2/2     Running   0          41s
pod/echo-6968d87679-x2hjg   2/2     Running   0          41s

NAME                              DESIRED   CURRENT   READY   AGE
replicaset.apps/echo-6968d87679   3         3         3       41s

NAME                   READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/echo   3/3     3            3           41s
```

- Deployment のリビジョンを確認

```
$ kubectl rollout history deployment echo
deployment.apps/echo
REVISION  CHANGE-CAUSE
1         kubectl.exe apply --filename=simple-deployment.yaml --record=true
```

### 5.8.1 ReplicaSet ライフサイクル

- k8s では Deployment を 1 つの単位として、アプリケーションをデプロイする。
- 実運用では ReplicaSet を直接用いることは少ない

- Deployment が管理する ReplicaSet

  - 指定された Pod 数の確保
  - 新しいバージョンの Pod への入れ替え
  - 以前のバージョンへの Pod のロールバック

- Pod 数のみを更新しても新規 ReplicaSet は生まれない
- マニフェストファイルの replicas を 3 から 4 に変更

```
$ kubectl apply -f simple-deployment.yaml --record
deployment.apps/echo configured
```

- 既存の Pod がそのままで 1 つのコンテナが新たに作成されている

```
$ kubectl get pod
NAME                    READY   STATUS    RESTARTS   AGE
echo-6968d87679-pxpbt   2/2     Running   0          60m
echo-6968d87679-t5t2j   2/2     Running   0          60m
echo-6968d87679-wzkvh   2/2     Running   0          38s
echo-6968d87679-x2hjg   2/2     Running   0          60m
```

- 新しく ReplicaSet が生成されていればリビジョン番号 2 が表示されるはずですが、1 のまま => replicas の変更では ReplicaSet の入れ替えが発生しないということ

```
$ kubectl rollout history deployment echo
deployment.apps/echo
REVISION  CHANGE-CAUSE
1         kubectl.exe apply --filename=simple-deployment.yaml --record=true
```

- コンテナ定義を更新
- simple-deployment.yaml の echo コンテナのイメージを変更

```
- name: echo
  image: gihyodocker/echo:patched // ← 変更する
  ports:
  - containerPort: 8080
```

- Deployment を反映

```
$ kubectl apply -f simple-deployment.yaml --record
deployment.apps/echo configured
```

- 新しい Pod が作成され、古い Pod が段階的に停止していく

```
$  kubectl get pod --selector app=echo
NAME                    READY   STATUS        RESTARTS   AGE
echo-54dbdb57c7-8jvfm   2/2     Running       0          49s
echo-54dbdb57c7-h6dkl   2/2     Running       0          50s
echo-54dbdb57c7-jxsh9   2/2     Running       0          40s
echo-54dbdb57c7-vmxfs   2/2     Running       0          36s
echo-6968d87679-pxpbt   0/2     Terminating   0          69m
echo-6968d87679-t5t2j   0/2     Terminating   0          69m
echo-6968d87679-x2hjg   2/2     Terminating   0          69m
```

- 最終的には新しい Pod のみになる。

```
$  kubectl get pod --selector app=echo
NAME                    READY   STATUS    RESTARTS   AGE
echo-54dbdb57c7-8jvfm   2/2     Running   0          3m26s
echo-54dbdb57c7-h6dkl   2/2     Running   0          3m27s
echo-54dbdb57c7-jxsh9   2/2     Running   0          3m17s
echo-54dbdb57c7-vmxfs   2/2     Running   0          3m13s
```

- Deployment のリビジョン確認
  - リビジョン 2 が作成されている。 => Deployment の内容に変更があると新しいリビジョンが作成される

```
$ kubectl rollout history deployment echo
deployment.apps/echo
REVISION  CHANGE-CAUSE
1         kubectl.exe apply --filename=simple-deployment.yaml --record=true
2         kubectl.exe apply --filename=simple-deployment.yaml --record=true
```

### 5.8.2 ロールバックを実行する

- Deployment のリビジョンが記録されているため、特定のリビジョンの内容を確認できる

```
$ kubectl rollout history deployment echo --revision=1
deployment.apps/echo with revision #1
Pod Template:
  Labels:       app=echo
        pod-template-hash=6968d87679
  Annotations:  kubernetes.io/change-cause: kubectl.exe apply --filename=simple-deployment.yaml --record=true
  Containers:
   nginx:
    Image:      gihyodocker/nginx:latest
    Port:       80/TCP
    Host Port:  0/TCP
    Environment:
      BACKEND_HOST:     localhost:8080
    Mounts:     <none>
   echo:
    Image:      gihyodocker/echo:latest
    Port:       8080/TCP
    Host Port:  0/TCP
    Environment:        <none>
    Mounts:     <none>
  Volumes:      <none>
```

- undo を実行すれば直前の操作のリビジョンに Deployment をロールバックができる
  - 最新の Deployment に問題があった場合にすぐに以前のバージョンに戻すことができる

```
$ kubectl rollout undo deployment echo
deployment.apps/echo rolled back
```

- Deployment と、関連する Replicast と Pod の削除

```
$ kubectl delete -f simple-deployment.yaml
deployment.apps "echo" deleted
```

## 今日の学び

- k8s のマニフェストファイルはあくまでもコンテナをどう配置するのかということに集中できる。つまり、コンテナ自体をどういう構成にするかということは Docker イメージを作成時点に考慮しておく必要がある。
- kubectl のコマンド調べてた時によさげな翻訳サイトあったのでメモ
  - [Introduction · The Kubectl Book 日本語訳](https://kubectl-book-ja.netlify.app/)
- kubectl apply の-f と-k オプションの違いってなんだろう？？
- Deployment は ReplicaSet の上位のリソースでバージョン管理やロールバックが行えて便利。
