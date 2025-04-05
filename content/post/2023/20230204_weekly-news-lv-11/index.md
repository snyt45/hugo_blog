---
title: "週刊ニュース Lv11（2023年1月28日～2023年2月3日）"
description:
slug: "weekly-news-lv-11"
date: 2023-02-04T01:46:25+0900
lastmod: 2023-02-04T01:46:25+0900
image:
math:
draft: false
---

## 1 月 28 日(土)

特になし

## 1 月 29 日(日)

Go 言語で対戦シューティングゲームを作る１

- 仕事でデジタルスペースで会議などができる Gather を使っていて、RPG のような 2D キャラクターが動いていてオンラインで同期させる仕組みなどが気になっていました。そのときは色々調べてみたものの結局どういう技術を使って実現させているかわかりませんでした。
- そこからだいぶ時間が空いたのですが最近は Go 言語をやっていてモチベーションがあがる教材はないかなと探していたらベストな記事を見つけました。
- https://qiita.com/tashxii/items/75b99c32b024a1c06eb7
- Go 言語で WebSocket サーバーを立てて 2 クライアント間で対戦シューティングゲームを作るというものです。
- Gather と全く同じ技術ではないにしてもどのように同期を取るのか、ゲームはどんな仕組みがあれば作れるのか、そして Go 言語を実際にどう使っていくのかという自分のモチベーションを保てそうな教材でした。
- この日はサーバーにアクセスしたら index.html を返して、index.html が描画されるときに WebSocket サーバーに接続するという部分をやりました。
- 初めて、Gin や Melody といった Go 言語のライブラリに触れられてみたのですが面白いです。

## 1 月 30 日(月)

rubyXL で入力規則を設定すると、特定の条件のときに Excel が壊れる

- rubyXL は Excel を扱うときに便利なライブラリです。
- Excel の知識がなくても扱いやすいように色々な処理を rubyXL がやってくれているっぽいのですが、rubyXL で生成した Excel を開く時に「一部の内容に問題が見つかりました」となって壊れてしまう不具合がありました。
- ある程度前回調べた時にアタリはついていたものの Excel 側の知識を必要とする不具合でした。
- 下記のツイートは参考です。
  - https://twitter.com/furyutei/status/1514076678838177800
- 内容は違いますが、Formula1 に記号が入ってしまうとうまく Excel 側が読み込めないというものでした。Excel は unzip したら実態は XML になっていると先週学びましたが Excel の知識がないと XML 側の`<formula1>文字列</formula1>`がどのように使われるのかとか全然わからないなーと思いました。Excel ムズいです…

Go 言語で対戦シューティングゲームを作る２

- 参考コードで下記のようなコードが出てきたので調べました。
- ```javascript
  make(map[*melody.Session]*TargetInfo)
  ```
- make で map を初期化
- map の key は`*melody.Session`です。これは`melody.Sessionのポインタ型`です。
- map の value は`*TargetInfo`です。これは`TargetInfoのポインタ型`です。
- もっと噛み砕くために型は組み込み型を使って理解してみます。
- ```javascript
  // mapのkeyはstring型のポインタ型です。
  // mapのvalueはint型のポインタ型です。
  x := make(map[*string]*int) // map[]

  // string型の変数を宣言
  var str1 string = "hello"
  // int型の変数を宣言
  var int1 int = 1
  // string型の変数str1のポインタを&をつけて引き出しそれをmapのkeyに指定
  // int型の変数int1のポインタを&をつけて引き出しそれをmapのvalueに指定
  x[&str1] = &int1
  fmt.Println(x) // map[0xc00009e020:0xc0000b4008]
  ```

- 最後の結果を見ればわかるように最初に`map[*string]*int`と宣言している`*string`には、string 型のポインタが、`*int`には int 型のポインタが代入できます。
- これらのことから最初のコードは`melody.Sessionのポインタ型`と`TargetInfoのポインタ型`の組を保存するために宣言しているんだなーというのが読み取ることができました。

## 1 月 31 日(火)

slack-notifier の attachment は Slack の attachment に対応している

- Slack 通知をする gem を使って通知の文章を変更したいとおもったときにどのようにすればいいのかと色々調べました。slack-notifier の attachment は Slack の attachment に対応していました。Slack の attachment の例を参考に色々試していい感じにできました。
- slack-notifier
  - https://github.com/slack-notifier/slack-notifier#:~:text=web/favicon.png%22-,Adding%20attachments%3A,-a_ok_note%20%3D%20%7B
- Slack の attachmet
  - https://api.slack.com/reference/messaging/attachments#example
- こちらも参考になりました
  - https://websas.jp/column/397

## 2 月 1 日(水)

早くプロダクトで売上を上げられるに頑張りたい

- 今は MVP と同時並行でプロダクトを開発している感じなのでガンガンいろんな人に使ってもらうぞーというフェーズではありません。そのためお金を稼ぐプロダクトにはまだ遠い状況です。つまり、お金を稼ぐコードにもなっていないので自分が頑張って実装したコードも無駄になる可能性はまだまだあります。だからこそ、早く世に出してお金を稼ぐコードになって自分の頑張りが報われるように頑張りたいです。

## 2 月 2 日(木)

google-protobuf ってリポジトリの構成が難しい

- 大体の gem は gem 専用のリポジトリがあるのでそのリポジトリのリリースを追っていればいいのですが、google-protobuf はモノレポみたいな感じで一つのリポジトリで色々な言語の実装があり、Ruby 実装もその一つです。
- Ruby3.2 のバージョンアップで google-protobuf のバージョンアップを追っているのですが、Ruby 実装の元となる方は[プレリリース](https://github.com/protocolbuffers/protobuf/releases/tag/v22.0-rc1)されたみたいなのですが、まだ RubyGems を見る限り Ruby 実装のバージョンアップはきていないようです。
- こういう構成のリポジトリはバージョンアップを追跡するのが難しいですね。

AWS の請求が 500 円きていた

- 年始に AWS を無料で使いだしたのですが、無料の範囲を超えた部分の請求がありました。
- EC2 インスタンスは削除しておいたのにと思いながら見るとたしかに EC2 インスタンスの請求ではありませんでした。
- ECS インスタンスの料金ではなく、Elastic IP や NAT ゲートウェイでお金がかかってしまっていたみたいでした。
- Elastic IP や NAT ゲートウェイって使われていなくて確保？しているだけでお金がかかるんですね…一旦削除したのでこれで来月は請求がこないはずです…

## 2 月 3 日(金)

Go 言語で対戦シューティングゲームを作る３

- 少しずつ楽しくなってきました。
- 参考コードは index.html の script タグに javascript 直書きなのですが、モジュールに分割したいと思いやってみるとできました。今はすべてのブラウザがモジュールの仕組みを使えるんですね。(普段からフロント側は他のコードを見ながら雰囲気で書いているのがバレますね…)
  - > JavaScript には、モジュールという仕組みがあります。ECMAScript 2015 の Modules の標準仕様として策定されており、現在はすべてのブラウザで利用できます。
    > https://ics.media/entry/16511/
- そうなってくると今度は TypeScript を使いたいなーとなってきたのですがいろんなライブラリを入れてガッチリではなく最小限で導入したいとなり、できるのだろうかと思っていたのですができました。ポイントは RequireJS を使うというところでした。HTML と typescript のライブラリと RequireJS があれば TypeScript の実行環境をつくれました。
  - https://qiita.com/Kontam/items/cd0c44f37914a9c283c4
- ただ、今後は Gin で静的ファイルをホスティングするのがうまくいかなくなりました。。
