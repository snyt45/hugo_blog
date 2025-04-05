---
title: "週刊ニュース Lv9（2023年1月14日～2023年1月20日）"
description:
slug: "weekly-news-lv-9"
date: 2023-01-21T01:37:13+0900
lastmod: 2023-01-21T01:37:13+0900
image:
math:
draft: false
---

今週もいつも通り淡々とやりたいことを進めていました。今週も振り返っていきましょう。

## 1 月 14 日(土)

Apollo Client と@graphql-codegen/typescript-react-apollo と仲良くなった

- 以前、諦めたのですがやっぱり気になって色々調べてみました。
  - Apollo Client で ErrorLink を使って高度なエラー処理ができますが、ErrorLink の中で throw した例外が捕捉できずにドはまりしました
- Apollo Client の方向性では難しいと思いつつ調べていると、ほぼ同じ悩みの記事を見つけました。
  - https://blog.studysapuri.jp/entry/gql-codegen-ts-react-apollo-memories
- 記事では、@graphql-codegen/typescript-react-apollo の`apolloReactHooksImportFrom`を使い codegen で自動生成される hooks を独自の hooks を使うことで解消していました。
- 色々省略するのですが、codegen すると生成される hooks 内部では Apollo から下記を呼び出しているようでした。
  - Apollo.MutationHookOptions
  - Apollo.useMutation
  - Apollo.QueryHookOptions
  - Apollo.useQuery
  - Apollo.LazyQueryHookOptions
  - Apollo.useLazyQuery
- この Apollo 部分が ApolloReactHooks に置き換わるので、ApolloReactHooks で使えるようにする必要がありそうなことがわかりました。
- ここまで調べたり、試してみて実装できそうなことはわかったのですが、思った以上に対応に時間がかかりそうだと思い、以前諦めた Apollo Client については実装をしっかり見れていなかったのでコードを読んだりしてこの日は力尽きました。

## 1 月 15 日(日)

特になし

## 1 月 16 日(月)

attr_accessor のセッターを使って値をセットしようとしてもセットされない

- まさに下記の記事と同じ内容でした。Form オブジェクト内で attr_accessor のセッターを使って値をセットしようとしてもセットできませんでしたが、self をつけるとセッターと認識し値をセットできました。
- https://ysk-pro.hatenablog.com/entry/attr_accessor

## 1 月 17 日(火)

報告が苦手だなと思った

- アジャイルの現場なので毎朝デイリースクラムがあり、そこで各自やったこと、やること共有するのですが報告が上手い人は内容が整理されていてぱっと状態を把握できるのですごいと思いました。

メールクライアントで送信者名を表示させる

- 特別な対応をする必要はなく、`送信者名 <noreply@example.com>`という形式で From を設定することでよかったです。また、Rails では`email_address_with_name`というメソッドが用意されていたのでこれを使いました。
  - https://railsguides.jp/action_mailer_basics.html#%E3%83%A1%E3%83%BC%E3%83%AB%E3%82%A2%E3%83%89%E3%83%AC%E3%82%B9%E3%82%92%E5%90%8D%E5%89%8D%E3%81%A7%E8%A1%A8%E7%A4%BA%E3%81%99%E3%82%8B

## 1 月 18 日(水)

@graphql-codegen/typescript-react-apollo + react-router を組み合わせてエラー内容に合わせてコンポーネントを出し分けする

- フロントが得意な人の力を借りることで GraphQL リクエストで 404 エラーを受け取ったときにエラー用コンポーネントを表示するという土台を構築することができました。
- エラーを throw する部分については、@graphql-codegen/typescript-react-apollo の`apolloReactHooksImportFrom`を使い codegen で自動生成される hooks を独自の hooks を使うことで実現しました。
- エラーを catch する部分については、react-routerv6.4 から導入された errorElement 機能を使って router 内のエラーを catch したら errorElement で対応するエラー用コンポーネントを表示するようにしました。
- エラーを throw する部分が Apollo Client を使うと onError を使って throw しても内部で握りつぶされていたりで共通化のボトルネックとなっていましたが、@graphql-codegen/typescript-react-apollo の`apolloReactHooksImportFrom`のおかげで実現することができました。
- @graphql-codegen/typescript-react-apollo の`apolloReactHooksImportFrom`はとても便利なのでぜひ活用してみてください。

## 1 月 19 日(木)

特になし

## 1 月 20 日(金)

Ruby3.2 へのバージョンアップ

- 破壊的な変更があったり、gem 側がまだサポートされていなかったり、サポートされていても gem をアップデートする必要があったりと一筋縄ではいかなさそうです…
- https://www.ruby-lang.org/ja/news/2022/12/25/ruby-3-2-0-released/
