---
title: "Postmanでログイン認証"
description:
slug: "postman-session-sync"
date: 2021-06-02T01:04:18+0000
lastmod: 2021-06-02T01:04:18+0000
image:
math:
draft: false
---

Rails のバージョン：5.2

Rails のログイン認証画面に Postman で Post してログイン認証をやってみた。  
すると、`ActionController::InvalidAuthenticityToken`が出た。

Rails の CSRF 対策によるもの。

## CSRF とは

A さんがプロジェクト管理サービスにログイン  
↓  
ログアウトせずに、そのまま掲示板サイトを閲覧  
↓  
とある書き込みをブラウザが読み込む(`<img src="http://pj-service.com/project/1/destroy>`)  
↓  
ブラウザから上記 URL に対してリクエストが走る(このとき、まだ有効な Cookie が送信されるため認証後の画面でもリクエストが通ってしまう)  
↓  
A さんが知らないうちにプロジェクトが削除されている。

ブラウザが異なるドメインからのリクエストでも、そのドメインで利用できる Cookie がある場合送信するというブラウザの仕様を突いたものみたいだ。

[Rails セキュリティガイド \- Rails ガイド](https://railsguides.jp/security.html#%E3%82%AF%E3%83%AD%E3%82%B9%E3%82%B5%E3%82%A4%E3%83%88%E3%83%AA%E3%82%AF%E3%82%A8%E3%82%B9%E3%83%88%E3%83%95%E3%82%A9%E3%83%BC%E3%82%B8%E3%82%A7%E3%83%AA-csrf)

## CSRF 対策とは

> GET 以外のリクエストにセキュリティトークンを追加することで、Web アプリケーションを CSRF から守ることができます。

[Rails セキュリティガイド \- Rails ガイド](https://railsguides.jp/security.html#csrf%E3%81%B8%E3%81%AE%E5%AF%BE%E5%BF%9C%E7%AD%96)

下記をアプリケーションコントローラに設定することで CSRF 対策が有効になる。

```
protect_from_forgery with: :exception
```

ちなみに Rails5.2 以降ではデフォルトで有効になっているみたいで定義はされていなかった。

> Rails5.2 以降では ActionController::Base 内で有効になっているため、デフォルトの設定でよければ自分で記述する必要はない

[Rails の CSRF 対策について \- Qiita](https://qiita.com/eshow/items/915f8e8ad317aa8e49a6)

具体的には下記のことをやってみるみたいだ。

> rails は、get 以外の動詞のリンクに、authenticity_token というパラメータを自動的に付け加えます。get 以外の動詞の各アクションで params[:authenticity_token]と session[:csrf_id]を比較して、同値であれば OK としているようです。\*1 同値でなければ ActionController::InvalidAuthenticityToken という例外がでます。

[CSRF の対応について、rails 使いが知っておくべきこと \- おもしろ web サービス開発日記](https://blog.willnet.in/entry/20080509/1210338845)

## CSRF 対策が有効のままでどう認証を突破するか

本題です。

Postman で Rails の認証を突破する方法ですが、ググってもそもそも CSRF 対策を無効にしようみたいな記事ばかりだったので今回自分でいろいろ試してみました。

### その１：authenticity_token と ID と Password を Postman から送信してみる

CSRF トークンは HTML に埋め込まれているので、ログイン画面の CSRF トークンを取得。  
ブラウザのコンソールで下記を実行すると取得できます。  
HTML 要素なので目視で探してもいいです。

```
document.getElementsByName('csrf-token')[0].content
```

次にブラウザのコンソールを開いたまま画面から実際にログインしてみます。

ネットワークタブから該当のアクセスを探して、Headers > Form Data を見ます。

authenticity_token  
user[login]  
user[password]

が送信されています。

同じように上記のパラメータを Postman からログイン画面に Post してあげればよさそうですね。

ログアウトして、authenticity_token は新しいものを取得しましょう。

これで送信してみますがダメでした。

### その２：画面でログインして、ログイン後のセッションを使う

ブラウザのコンソールを開いたまま画面から実際にログインします。

ネットワークタブからログイン後のページのアクセスを探して、Headers > Request Headers > Cookie を見ます。

`_src_session`のキーと値をコピーします。  
Postman の Cookies に追加します。

この状態でログイン認証が必要なページに GET すると、なんと成功します。

ログイン認証後のセッションがあれば問題なくログインできるようですね。

### その３：ブラウザのセッション情報を Postman と同期する

その２の方法でもよいですが、毎回面倒です。

ブラウザのセッション情報を Postman と同期する方法がありました。

[Postman で Cookie が必要な API を実行する \- ユニファ開発者ブログ](https://tech.unifa-e.com/entry/2021/05/10/083532)

この方法なら、画面でログインするだけで Postman に認証後のセッション情報が同期されているので、先ほどの面倒な手順なくリクエストを投げれば成功します。

逆に画面でログアウトすれば認証が必要なリクエストの場合は失敗します。

## まとめ

セッションさえ偽造できればログイン後の画面にアクセスできる。  
ブラウザは毎回送信できる Cookie があれば送信している。  
Postman とブラウザのセッション情報を同期すれば認証後の画面へのリクエストが思いのままに投げられる。

本来は API を投げる際はトークン認証とかなのですがそういった実装がなくとりあえずログイン認証後の画面の URL にリクエスト投げたい場合の TIPS でした。
