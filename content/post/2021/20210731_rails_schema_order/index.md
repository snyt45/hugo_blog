---
title: "rails db:migrateでスキーマの順番が変わる問題でやったこと"
description:
slug: "rails_schema_order"
date: 2021-07-31T01:23:08+0000
lastmod: 2021-07-31T01:23:08+0000
image:
math:
draft: false
---

`rails db:migrate`を行うと、schema.rb のカラム順が変わる問題が発生したときにやったことのメモです。

DB は PostgreSQL を使い、annotate というモデルのスキーマ情報をファイルにコメントとして書き出してくれる gem を使っています。

## 作業メモ

マイグレーションファイルを 1 つ追加する(この時点で未実行のマイグレーションファイルは 1 つだけ)。

```
rails db:migrate
```

今回追加した以外の箇所もスキーマが更新されてしまった(カラム順が変わっている)。

一からマイグレーションしなおしてみる。

```
rails db:migrate:reset
```

上記で annotate はうまくいったけど、やっぱり今回追加した以外の箇所もスキーマが更新されてしまった。

一旦、差分が出た schema.rb の変更分は元の状態に戻して、`db:reset`を行う。

```
rails db:reset
```

`db:reset`は schema.rb を正としてテーブルを再作成するので、スキーマはこの時点では変化なし。

再度、`db:migrate`で未実行のマイグレーションのみ実行すると、未実行のマイグレーション箇所のみスキーマが更新された！

```
rails db:migrate
```
