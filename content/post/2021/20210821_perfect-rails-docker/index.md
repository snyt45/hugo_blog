---
title: "パーフェクトRuby on Railsで何度もrails newできる環境をDockerで作る"
description:
slug: "perfect-rails-docker"
date: 2021-08-21T01:39:15+0000
lastmod: 2021-08-21T01:39:15+0000
image:
math:
draft: false
---

## モチベーション

パーフェクト Ruby on Rails を 1 ～ 3 章まで進めてみたのですが、とにかく rails new の頻度が多いです。

ローカルを汚したくないので Docker(docker-compose)で完結するようにやっていたのですが、

rails new するために色々手間だったので学習効率をあげるためにもう少し簡単にできないか模索してみました。

## 参考にした記事

[Docker を使って手元の環境に Ruby や Rails を入れずに rails new した結果を手に入れる \- コード日進月歩](https://shinkufencer.hateblo.jp/entry/2020/08/06/233446)

もともと docker-compose 構成で[こちらのリポジトリ](https://github.com/snyt45/perfect-rails2)でやっていましたが Dockerfile 一つでもいけるのかと思ったので Dockerfile のみでやるようにしてみました。

## 最終的な Dockerfile のリポジトリ

Dockerfile は github にあげておきました。

[snyt45/perfect\-rails\-docker: 何度も rails new できるコンテナ設定](https://github.com/snyt45/perfect-rails-docker)

## やりたいこと

- 1 つのコンテナの中で rails new を何回もできるようにしたい。
- DB は SQLite3 で OK ※MySQL を使ったセットアップすると少し面倒そうなので…
- rails server 起動したら localhost:3000 で接続できること
- ファイル編集はしたいのでホストの Dockerfile と同じディレクトリをコンテナにマウントする

## やったこと

### Dockerfile

ほぼ参考にした記事通りですが、rails new をしないようにしています。

rails6 に必要な ruby と nodejs と yarn を入れて、ruby を入れたら使える gem コマンドで rails をインストールするところまでのイメージを作るようにしてみました。

また、app ディレクトリを作っていますがこの配下に複数プロジェクトを配置するイメージです。

```
ARG ruby_version
FROM ruby:${ruby_version}

# nodejsをインストール
RUN curl -LO https://nodejs.org/dist/v12.18.3/node-v12.18.3-linux-x64.tar.xz
RUN tar xvf node-v12.18.3-linux-x64.tar.xz
RUN mv node-v12.18.3-linux-x64 node
ENV PATH /node/bin:$PATH

# yarnをセットアップする
# 公式ドキュメントまま https://classic.yarnpkg.com/ja/docs/install/#alternatives-stable
RUN curl -o- -L https://yarnpkg.com/install.sh | bash
ENV PATH /root/.yarn/bin:/root/.config/yarn/global/node_modules/.bin:$PATH

ARG rails_version
RUN gem install rails -v "${rails_version}"

RUN mkdir /app
ENV APP_ROOT /app
WORKDIR $APP_ROOT
```

### イメージ作成

カレントディレクトリの Dockerfile を使用。

イメージ名は perfect-rails で、ruby は 2.6.3、rails は 6.0.1 のバージョンを指定しています。

```
docker build . -t perfect-rails --build-arg ruby_version=2.6.3 --build-arg rails_version=6.0.1
```

### イメージからコンテナ起動

perfect-rails というイメージを元にコンテナを起動。

-d でバックグラウンド実行しています。

-t を付けておかないとコンテナが停止してしまうのでつけています。

-p でホスト側の 3000 番ポートにアクセスがあったら、コンテナの 3000 番ポートにポートフォワーディングさせるようにしています。

--name でコンテナの名前を perfect-rails にしています。

-v でカレントディレクトリをコンテナの app ディレクトリにマウントします。

```
# fish
docker run -d -t -v (pwd):/app -p 3000:3000 --name="perfect-rails" perfect-rails
```

コンテナが起動していることを確認する。

```
❯ docker ps
CONTAINER ID   IMAGE           COMMAND   CREATED          STATUS          PORTS
  NAMES
b7c53f1277cc   perfect-rails   "irb"     30 seconds ago   Up 29 seconds   0.0.0.0:3000->3000/tcp, :::3000->3000/tcp   perfect-rails
```

### 複数プロジェクト作成、サーバー起動、localhost:3000 に接続できることを確認する

#### 1 つ目のプロジェクト作ってみる

rails new する。

database はデフォルトの sqlite3 でいいので何も指定しない。

```
docker exec -it perfect-rails /bin/bash
rails new sample_app_1
```

sample_app_1 フォルダが作成されました。

```
.
├── Dockerfile
└── sample_app_1
```

サーバー起動して、localhost:3000 に接続できることを確認します。

```
cd sample_app_1
rails s -p 3000 -b '0.0.0.0'
```

接続できました！

#### 2 つ目のプロジェクト作ってみる

rails server は停止しておきます。

さっきと同じ手順で実行します。

rails new して新しいプロジェクトを作成します。

```
rails new sample_app_2
```

新しく sample_app_2 フォルダが作成されました。

```
.
├── Dockerfile
├── sample_app_1
└── sample_app_2
```

サーバー起動して、localhost:3000 に接続できることを確認します。

```
cd sample_app_2
rails s -p 3000 -b '0.0.0.0'
```

同じく接続できました！

### コンテナを停止して再起動する

運用してはコンテナを停止して再起動して使います。

```
docker stop perfect-rails
docker strat perfect-rails
```

docker start 後に docker ps してみると、ポートフォワーディングも設定された状態のコンテナが起動していることが確認できます。

```
❯ docker ps
CONTAINER ID   IMAGE           COMMAND   CREATED          STATUS         PORTS
 NAMES
b7c53f1277cc   perfect-rails   "irb"     16 minutes ago   Up 3 seconds   0.0.0.0:3000->3000/tcp, :::3000->3000/tcp   perfect-rails
```

### まとめ

パーフェクト Ruby on Rails で rails new が出てきてもこれで 1 つのコンテナ内で対応できるようになりました！

これでいくらでも試せる環境ができたので学習効率があがりそう。
