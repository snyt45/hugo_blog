---
title: "Docker/Kubernetes 実践コンテナ開発入門@32日目"
description:
slug: "docker-kubernetes-32days"
date: 2020-11-16T16:08:18+0000
lastmod: 2020-11-16T16:08:18+0000
image:
math:
draft: false
---

[Docker/Kubernetes 実践コンテナ開発入門：書籍案内｜技術評論社](https://gihyo.jp/book/2018/978-4-297-10033-9)

## 6.7 オンプレミス環境での Kubernetes クラスタの構築

- k8s は OSS のため、オンプレミス環境においてもクラスタを構築可
- kubespray を使用してクラスタ構築

## 6.8 kubespray で Kubernetes クラスタを構築する

- テキストに書いてあるサーバを用意するのが難しいのでここからはメモだけ。

### 6.8.1 クラスタとして構築するサーバの準備

- master
  - node の管理、Serviece、Pod といったリソースの管理を行う司令塔
  - クラスタの可用性を確保するために 3 台配置することが推奨
  - オンプレミス環境では開発者が構築・メンテナンスを行う必要がある。
- node
  - Pod のデプロイ先
- ops
  - kubespray を実行するための作業用サーバ
  - k8s のクラスタには入らない
  - ops から Ansible を利用して kubespray を実行 → Master と Node を k8s クラスタとして構成

### 6.8.2 ops の SSH 公開鍵の登録

- ops にて公開鍵(.pub)と秘密鍵を作成する。
- 公開鍵はログインする master と node サーバに置く

### 6.8.3 IPv4 フォワーディングを有効にする

- /etc/sysctl.conf の net.ipv4.ip_forward のコメントアウトを外す
- 変更反映のため、サーバ再起動

- ops
  - Ansible と netaddr をインストール
  - Ansible のセットアップ

### 6.8.4 クラスタの設定

- inventory/mycluster/hosts.ini
  - クラスタを構成するサーバの設定
  - Master と Node を設定できる
- inventory/mycluster/group_vars/k8s-cluster.yml
  - kubernetes のバージョンや、Dashboard のプリインストールの設定等を行うことができる

### 6.8.5 クラスタ構築の実行

- ansible-playbook コマンドを実行すると、クラスタの構築が開始される
- およそ 20 分～ 30 分で構築が完了する
- 完了したら、kubectl コマンドを実行できるか確認する

## 今日の学び

- 今日はテキストをなぞるだけであったがローカルでも k8s のクラスタ構築ができることを知れた。
- ローカルでもできるとはいえ、メンテナンス等を考えるとクラウドのほうがよさそうなイメージではある。
