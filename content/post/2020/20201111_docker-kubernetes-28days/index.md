---
title: "Docker/Kubernetes 実践コンテナ開発入門@28日目"
description:
slug: "docker-kubernetes-28days"
date: 2020-11-11T16:00:25+0000
lastmod: 2020-11-11T16:00:25+0000
image:
math:
draft: false
---

[Docker/Kubernetes 実践コンテナ開発入門：書籍案内｜技術評論社](https://gihyo.jp/book/2018/978-4-297-10033-9)

前回は GCP 上で k8s クラスタを作成するための導入でした。

6 章では TODO アプリを公開していきますが、今回はその構成のうちの MySQL を構築していきます。

## 6.2 GKE 上に TODO アプリケーションを構築する

- k8s のリソースで Docker をラップして GKE 上に TODO アプリケーションを構築
- MySQL → API → Web アプリケーションの順でデプロイ。最終的に Ingress で公開

## 6.3 Master Slave 構成の MySQL を GKE 上に構築する

- k8s では、ホストから分離可能な外部ストレージをボリュームとして利用
- この仕組みを実現する k8s のリソース
  - PersistentVolume
  - PersistentVolumeClaim
  - StorageClass
  - StatefulSet

### 6.3.1 PersistentVolume と PersistentVolumeClaim

- PersistentVolume
  - ストレージの実体
- PersistentVolumeClaim

  - PersistentVolume に対して必要な容量を動的に確保

- PersistentVolumeClaim のマニフェストファイルのイメージ

```
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-example
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: ssd // ← 実体はStorageClassリソース
  resources:
    requests:
      storage: 4Gi
```

- accessModes
  - Pod からストレージへのマウントポリシー
  - ReadWriteOnce は 1 つのノードからの R/W マウントのみ許可
- srorageClassName
  - 利用するストレージの種類
- resources.requests.storage
  - 必要な容量を指定

### 6.3.2 StorageClass

- StorageClass
  - PersistentVolume が確保するストレージの種類を定義
  - 直前の PersistentVolumeClaim の storageClassName で指定した値の実体
- GCP のストレージ
  - 「標準」と「SSD」が存在
- storage-class-ssd.yaml

```
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: ssd
  annotations:
    storageclass.kubernetes.io/is-default-class: "false"
  labels:
    kubernetes.io/cluster-service: "true"
provisioner: kubernetes.io/gce-pd
parameters:
  type: pd-ssd
```

- SSD に対応
- provisioner
  - GCEPersistentDisk に対応した VolumePlugin の gce-pd を指定
- parameters

  - gce-pd のパラメータの type 属性に SSD に対応した pd-ssd を指定

- StorageClass を作成

```
$ kubectl apply -f storage-class-ssd.yaml
storageclass.storage.k8s.io/ssd created
```

### 6.3.3 StatefulSet

- StatefulSet

  - データを永続化するステートフルなアプリケーションの管理に向いたリソース
  - Pod に pod-0、pod-1、pod-2 のような連番で一意な識別子で Pod が作成される
  - 識別子は Pod が再作成されても保たれる

- mysql-master.yaml
  - Master の設定

```
apiVersion: v1
kind: Service
metadata:
  name: mysql-master
  labels:
    app: mysql-master
spec:
  ports:
  - port: 3306
    name: mysql
  clusterIP: None
  selector:
    app: mysql-master // Serviceを介してStatefulSetのmysql-masterにアクセス
---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: mysql-master
  labels:
    app: mysql-master
spec:
  serviceName: "mysql-master"
  selector:
    matchLabels:
      app: mysql-master
  replicas: 1
  template:
    metadata:
      labels:
        app: mysql-master
    spec:
      terminationGracePeriodSeconds: 60
      containers:
      - name: mysql
        image: gihyodocker/tododb:latest
        imagePullPolicy: Always
        args:
        - "--ignore-db-dir=lost+found"
        ports:
        - containerPort: 3306
        env:
        - name: MYSQL_ROOT_PASSWORD
          value: "gihyo"
        - name: MYSQL_DATABASE
          value: "tododb"
        - name: MYSQL_USER
          value: "gihyo"
        - name: MYSQL_PASSWORD
          value: "gihyo"
        - name: MYSQL_MASTER
          value: "true"
        volumeMounts:
        - name: mysql-data
          mountPath: /var/lib/mysql
  volumeClaimTemplates: // ← ReplicaSetと違う点
  - metadata:
      name: mysql-data
    spec:
      accessModes: [ "ReadWriteOnce" ]
      storageClassName: ssd
      resources:
        requests:
          storage: 4Gi
```

- mysql-master の Service と StatefulSet を作成

```
$ kubectl apply -f mysql-master.yaml
service/mysql-master unchanged
statefulset.apps/mysql-master created
```

- StatefulSet はステートフルな ReplicaSet という位置づけ
- volumeClaimTemplate

  - PersistentVolumeClaim を Pod ごとに自動生成するためのテンプレートを定義できる

- mysql-slave.yaml
  - Slave の設定

```
apiVersion: v1
kind: Service
metadata:
  name: mysql-slave
  labels:
    app: mysql-slave
spec:
  ports:
  - port: 3306
    name: mysql
  clusterIP: None
  selector:
    app: mysql-slave

---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: mysql-slave
  labels:
    app: mysql-slave
spec:
  serviceName: "mysql-slave"
  selector:
    matchLabels:
      app: mysql-slave
  replicas: 2
  updateStrategy:
    type: OnDelete
  template:
    metadata:
      labels:
        app: mysql-slave
    spec:
      terminationGracePeriodSeconds: 60
      containers:
      - name: mysql
        image: gihyodocker/tododb:latest
        imagePullPolicy: Always
        args:
        - "--ignore-db-dir=lost+found"
        ports:
        - containerPort: 3306
        env:
        - name: MYSQL_MASTER_HOST // ← Masterの場所を知る必要があるため、MasterのService名を指定
          value: "mysql-master"
        - name: MYSQL_ROOT_PASSWORD
          value: "gihyo"
        - name: MYSQL_DATABASE
          value: "tododb"
        - name: MYSQL_USER
          value: "gihyo"
        - name: MYSQL_PASSWORD
          value: "gihyo"
        - name: MYSQL_REPL_USER
          value: "repl"
        - name: MYSQL_REPL_PASSWORD
          value: "gihyo"
        volumeMounts:
        - name: mysql-data
          mountPath: /var/lib/mysql
  volumeClaimTemplates:
  - metadata:
      name: mysql-data
    spec:
      accessModes: [ "ReadWriteOnce" ]
      storageClassName: ssd
      resources:
        requests:
        storage: 4Gi
```

- slave の Service と StatefulSet を作成

```
$ kubectl apply -f mysql-slave.yaml
service/mysql-slave created
statefulset.apps/mysql-slave created
```

- 作成された Pod の確認

```
$  kubectl get pod
NAME             READY   STATUS    RESTARTS   AGE
mysql-master-0   1/1     Running   1          14m
mysql-slave-0    1/1     Running   0          117s
mysql-slave-1    1/1     Running   0          99s
```

- 初期データを登録

```
$  kubectl exec -it mysql-master-0 init-data.sh
kubectl exec [POD] [COMMAND] is DEPRECATED and will be removed in a future version. Use kubectl kubectl exec [POD] -- [COMMAND] instead.
```

- Pod に反映されているか確認

```
$  kubectl exec -it mysql-slave-0 bash
kubectl exec [POD] [COMMAND] is DEPRECATED and will be removed in a future version. Use kubectl kubectl exec [POD] -- [COMMAND] instead.
root@mysql-slave-0:/#  mysql -u root -pgihyo tododb -e "SHOW TABLES;"
mysql: [Warning] Using a password on the command line interface can be insecure.
+------------------+
| Tables_in_tododb |
+------------------+
| todo             |
+------------------+
```

## 今日の学び

- 外部から Pod にアクセスできるように Service を作成
- StatefuleSet を使って master と slave の Pod を作成
- StatefulSet の中で volumeClaimTemplates を定義でき、ボリュームの容量やストレージタイプを定義。volumeMounts で volumeClaimTemplates で作成したボリュームを指定することでデータを永続化することができる。
