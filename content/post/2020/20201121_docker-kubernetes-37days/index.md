---
title: "Docker/Kubernetes 実践コンテナ開発入門@37日目"
description:
slug: "docker-kubernetes-37days"
date: 2020-11-21T16:19:01+0000
lastmod: 2020-11-21T16:19:01+0000
image:
math:
draft: false
---

[Docker/Kubernetes 実践コンテナ開発入門：書籍案内｜技術評論社](https://gihyo.jp/book/2018/978-4-297-10033-9)

前回は Helm を使った Redmine のインストール・アンインストールを行いました。

今回も引き続き Helm の使い方についてやっていきます。

## 7.3.5 RBAC に対応したアプリケーションをインストールする

- RBAC を有効にできるアプリケーションも多く存在
- RBAC を有効にした Chart をインストールする Tiller には cluster-admin の ClusterRole が必要

- ServiceAccount を作成
  - すでに存在するようだ

```
$ kubectl create serviceaccount tiller --namespace kube-system
Error from server (AlreadyExists): serviceaccounts "tiller" already exists
```

- ClusterRoleBinding を作成

```
$ kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
clusterrolebinding.rbac.authorization.k8s.io/tiller-cluster-rule created
```

- kube-system に patch をあてる

```
$ kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'
deployment.apps/tiller-deploy patched (no change)
```

- RBAC 制御に対応している Chart stable/jenkins を利用
- 現状は values.yaml をみると、デフォルトで RBAC をインストールする模様

```
## Install Default RBAC roles and bindings
rbac:
  create: true
  readSecrets: false
```

- stable/jenkins をインストール
- エラーがでる模様

```
$ helm install --name jenkins stable/jenkins
Error: failed to download "stable/jenkins" (hint: running `helm repo update` may help)
```

- Redmine のとき同様に stable/jenkins を bitnami/jenkins に変更したらいけた。
- と思ったけど、RBAC 周りがうまくいっていない模様。

```
helm install --name jenkins bitnami/jenkins
NAME:   jenkins
LAST DEPLOYED: Sat Nov 21 23:01:58 2020
NAMESPACE: default
STATUS: DEPLOYED

RESOURCES:
==> v1/Deployment
NAME     READY  UP-TO-DATE  AVAILABLE  AGE
jenkins  0/1    1           0          1s

==> v1/PersistentVolumeClaim
NAME     STATUS   VOLUME    CAPACITY  ACCESS MODES  STORAGECLASS  AGE
jenkins  Pending  standard  1s

==> v1/Pod(related)
NAME                      READY  STATUS   RESTARTS  AGE
jenkins-6c9f5cf86c-9kz7m  0/1    Pending  0         1s

==> v1/Secret
NAME     TYPE    DATA  AGE
jenkins  Opaque  1     1s

==> v1/Service
NAME     TYPE          CLUSTER-IP    EXTERNAL-IP  PORT(S)                     AGE
jenkins  LoadBalancer  10.55.254.12  <pending>    80:30882/TCP,443:30472/TCP  1s


NOTES:

** Please be patient while the chart is being deployed **

1. Get the Jenkins URL by running:

** Please ensure an external IP is associated to the jenkins service before proceeding **
** Watch the status using: kubectl get svc --namespace default -w jenkins **

  export SERVICE_IP=$(kubectl get svc --namespace default jenkins --template "{{ range (index .status.loadBalancer.ingress 0) }}{{.}}{{ end }}")
  echo "Jenkins URL: http://$SERVICE_IP/"

2. Login with the following credentials

  echo Username: user
  echo Password: $(kubectl get secret --namespace default jenkins -o jsonpath="{.data.jenkins-password}" | base64 --decode)
```

- 一度、アンインストール

```
$ helm delete jenkins
release "jenkins" deleted
```

- テキスト通り、カスタム values を作成する。
- jenkins.yaml

```
rbac:
  install: true
```

- 完全に削除しないといけないみたいだ。

```
$ helm del --purge jenkins
```

```
$ helm install -f jenkins.yaml --name jenkins bitnami/jenkins
NAME:   jenkins
LAST DEPLOYED: Sat Nov 21 23:10:32 2020
NAMESPACE: default
STATUS: DEPLOYED

RESOURCES:
==> v1/Deployment
NAME     READY  UP-TO-DATE  AVAILABLE  AGE
jenkins  0/1    1           0          0s

==> v1/PersistentVolumeClaim
NAME     STATUS   VOLUME    CAPACITY  ACCESS MODES  STORAGECLASS  AGE
jenkins  Pending  standard  0s

==> v1/Pod(related)
NAME                      READY  STATUS   RESTARTS  AGE
jenkins-6c9f5cf86c-2g69m  0/1    Pending  0         0s

==> v1/Secret
NAME     TYPE    DATA  AGE
jenkins  Opaque  1     0s

==> v1/Service
NAME     TYPE          CLUSTER-IP   EXTERNAL-IP  PORT(S)                     AGE
jenkins  LoadBalancer  10.55.245.6  <pending>    80:31692/TCP,443:30277/TCP  0s


NOTES:

** Please be patient while the chart is being deployed **

1. Get the Jenkins URL by running:

** Please ensure an external IP is associated to the jenkins service before proceeding **
** Watch the status using: kubectl get svc --namespace default -w jenkins **

  export SERVICE_IP=$(kubectl get svc --namespace default jenkins --template "{{ range (index .status.loadBalancer.ingress 0) }}{{.}}{{ end }}")
  echo "Jenkins URL: http://$SERVICE_IP/"

2. Login with the following credentials

  echo Username: user
  echo Password: $(kubectl get secret --namespace default jenkins -o jsonpath="{.data.jenkins-password}" | base64 --decode)
```

- うーん、うまくいかない
- ServiceAccout の設定を namespace を default、名前を jenkins にしてやり直す

```
$ kubectl patch deployment --namespace default jenkins -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'
deployment.apps/jenkins patched
```

- deployment の設定が書き換えられたことを確認する

```
$ kubectl get deployment jenkins -o yaml
```

- なんか色々違う気がしてきたのでやるべきことを整理する
- 名前空間 kube-system に ServiceAccount tiller を作成する
  - ちゃんと作成されているようだ。

```
$ kubectl get serviceaccount --namespace kube-system
NAME                                 SECRETS   AGE
...
tiller                               1         47h
...
```

- 名前空間 kube-system に ClusterRoleBinding tiller-cluster-rule があるか確認
  - ちゃんとある

```
$ kubectl get clusterrolebinding --namespace kube-system
NAME                                                   AGE
...
tiller-cluster-rule                                    52m
...
```

- 名前空間 kube-system の tiller-deploy に ServiceAccount が tiller になっているか確認
  - なっていた

```
$ kubectl get deploy tiller-deploy --namespace kube-system -o yaml
```

- tiller 側の準備は問題なくできていそうだ。
- 問題なのは bitnami/jenkins をインストールした際に ServiceAccount と ClusterRoleBinding が作成されていないこと

- 以前は rbac.install というオプションがあり、ServiceAccount と ClusterRoleBinding が作成されるようだが今はないみたいだ。
- 現在 rbac に関するオプションは以下のようだ。
- rbac.create
  - RBAC リソースを作成するかどうか
- rbac.readSecrets

  - Jenkins サービスアカウントが Kubernetes の秘密を読めるかどうか

- rbac.create では RBAC リソースを作成するかどうかで ServiceAccount と ClusterRoleBinding を作成するどうかではなくなっている。そのためだと思われる。

## 今日の学び

- 色々はまってしまったので今日はここまで。。
- 次回は独自の Chart を作成。ボリュームが多いので次回持越し。
