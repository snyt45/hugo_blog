---
title: "週刊ニュース Lv12（2023年2月4日～2023年2月10日）"
description:
slug: "weekly-news-lv-12"
date: 2023-02-11T01:48:03+0900
lastmod: 2023-02-11T01:48:03+0900
image:
math:
draft: false
---

## 2 月 4 日(土)

特になし

## 2 月 5 日(日)

TLS 経由でページをホストしているか調査

- Stripe 関連でページを TLS 経由でホストしているか調べる必要があったので調査しました。
- クライアント側から確認する
  - Chrome から調べることができました。
    - 参考：https://www.sukicomi.net/2021/03/chrome_tls_kakunin.html
  - TLS checker でも調べました。
    - 参考：https://scrapbox.io/nwtgck/WebサーバーがSSL%2FTLSのどのバージョンをサポートしているか調べるオンラインサービス
- サーバー側から確認する
  - ELB を使ってロードバランシングしていたので、ELB のセキュリティポリシーを確認しました。
  - `ELBSecurityPolicy-2016-08`を使っており、こちらは互換性のために tls1.0 tls1.1 tls1.2 をサポートしているようでした。
  - [🔗](https://docs.aws.amazon.com/ja_jp/elasticloadbalancing/latest/application/create-https-listener.html#describe-ssl-policies)https://docs.aws.amazon.com/ja_jp/elasticloadbalancing/latest/application/create-https-listener.html#describe-ssl-policies
- 結論として TLS に対応しているようでした。

## 2 月 6 日(月)

Go 言語で対戦シューティングゲームを作る４

- new WebSocket の直後に send すると、WebSocket 接続が確立する前に send してしまいエラーになるという事象が発生しました。setInterval を使って WebSocket 接続が確立されるまで試行して、send に成功したら setInterval を停止することで回避しました。
  - https://github.com/snyt45/gopher-war/blob/main/src/index.ts#L11-L22
- このとき初めて Go で dlb を使ってデバッグしてみたのですが、結構手順が多くて慣れるまで大変そうです。
- 前回、TS を使えるようにしたのですが Go 言語も慣れておらず、TS も慣れていないので実装するために学習するコストが高くつくなーと今更思いましたがせっかくの機会なのでゆっくりやっていこうと思います。

ログイン時にログイン情報を Slack に通知する

- Web アプリで特定のアカウントでログイン時にできるだけログイン時の情報を IP アドレスなどを含めて通知するということをやったのですが、引き出しが少なくあまり情報を出せませんでした。
- 後からこのサイトを見つけてこういう情報も出せたら良かったなと思ったので似たような要件のときに参考にしようと思いました。
  - https://abashi.net/user-info

## 2 月 7 日(火)

Rails で特定のディレクトリにコントローラーを自動生成する

- たまにしか使わないので忘れてしまいますが、generate コマンドは便利です。下記はコントローラーとコントローラーのテスト以外の不要なファイルは生成しないというオプションをつけてます。
- ```javascript
  rails g controller api/v1/posts index create --no-assets --no-helper --skip-routes --no-decorator --skip-template-engine
  ```
- https://qiita.com/terufumi1122/items/634dac88de01f3f73821

Rails で特定のコントローラーのルーティングを確認する

- いつもは`rails routes | grep xxx`みたいなことをしていたけどコントローラー名で絞り込めるのは知らなかった。
- ```javascript
  rails routes -c 【確認したいコントローラー名】
  ```
- https://www.tairaengineer-note.com/ruby-on-rails-rails-routes-specific-controller/

Go 言語で対戦シューティングゲームを作る５

- フロントから取得した json を Go の構造体に紐づけるのに json パッケージが便利。
- 参考：https://www.wakuwakubank.com/posts/794-go-json/
- melody で接続したクライアントにメッセージを送信するときは`s.Write([]byte(message))`が使えた。
- 参考： https://pkg.go.dev/github.com/olahol/melody#Session.Write

## 2 月 8 日(水)

composables ディレクトリに use なんちゃらを配置する

- フロントエンドディレクトリに composables というディレクトリがあり、その中に use○○ というファイルが配置されているのですが、改めて何故だっけ？となったので調べてみました。
  - composables
    - おそらく自社の場合の composables は Vue からきていそうです。「状態を持つ関数を配置するディレクトリ」という意味合いな気がしました。
    - https://www.memory-lovers.blog/entry/2022/06/04/180000#:~:text=Nuxt%203%20%2D%20useState-,Composables%E3%81%A8%E3%81%AF%EF%BC%9F,-Vue3%E3%81%AE%E3%83%89%E3%82%AD%E3%83%A5%E3%83%A1%E3%83%B3%E3%83%88
  - use○○
    - 自社で使っているのは React なので React の文脈だと思い React のドキュメントを調べてみました。
    - おそらくここらへんかなと。useObjective のような内部で他の useState、useQuery などのフックを呼び出している独自カスタムフックなので use○○ という感じなのかと思いました。
    - > カスタムフックとは、名前が ”use” で始まり、ほかのフックを呼び出せる JavaScript の関数のことです。
      > https://ja.reactjs.org/docs/hooks-custom.html#extracting-a-custom-hook
  - 結論
    - composables には状態を持つ関数が含まれる。
    - use○○ は内部でフックを呼び出している。また、composables に配置されている use○○ は状態も持っているから composables に配置している。

## 2 月 9 日(木)

Sidekiq7.x から`config.log_formatter`はエラーになる

- Sidekiq7.x へのバージョンアップをやっています。
- そのときに`undefined method log_formatter=`というエラーが出るようになりました。
- `config.logger.formatter`を使うようになったみたいです。
  - 参考：https://github.com/mperham/sidekiq/issues/4218#issuecomment-1420433857
- 調査したときのメモ
  - 7.x からは config 周りのメソッド等が新クラスの `Sidekiq::Config` に移されている
    - 6.5.x
      - `Sidekiq.configure_server` を呼ぶと Sidekiq クラス自身が持っている設定系のメソッドで設定されていた
      - `config.log_formatter`の`config`は Sidekiq クラス自身
    - 7.x
      - `Sidekiq.configure_server` を呼ぶと `default_configuration` が呼ばれるようになって、`default_configuration` では、 `Sidekiq::Config` を生成するので、`Sidekiq::Config` のメソッドが呼ばれるようになる
      - `config.log_formatter` の `config` は `Sidekiq::Config` になった
      - `Sidekiq::Config`は`#log_formatter`を持っていないのでエラーになるようになった。
      - 7.x からは`Sidekiq::Config`が Ruby の Logger を継承しているので、最終的には、 Ruby の`Logger#formatter=`が呼ばれていそう(未検証)

## 2 月 10 日(金)

Rails の minitest の Controller テストで 2 種類の親クラスが使われていた

- `ActionController::TestCase`と`ActionDispatch::IntegrationTest`が２つ使われていて、自動生成では`ActionDispatch::IntegrationTest`を継承したクラスが生成されていました。
- 調べてみると`ActionController::TestCase`は非推奨で今は`ActionDispatch::IntegrationTest`を使うみたいです。
- 参考：https://api.rubyonrails.org/classes/ActionController/TestCase.html
