---
title: "2022年9月の振り返り"
description:
slug: "2022-09-furikaeri"
date: 2022-10-01T01:01:37+0900
lastmod: 2022-10-01T01:01:37+0900
image:
math:
draft: false
---

先月のアウトプットは 2 記事でした。

書きたいことは結構ありますが、それ以上にやりたいことが先行してアウトプットが後回しになっていますね…これは世の常なのかもしれません…

## 第 2 領域： 9 月のかけた時間は 79.35 時間(先月：97.2 時間)

先月に比べて約 20 時間くらい減っていますが、いい感じにパソコン触っているのでいい感じです。
先月に引き続き今月も自分の開発環境周りに時間を捧げていました。

やったことが多すぎてすべては説明しきれていないですが、ざっくりとは記事にまとめたので気になるひとはよかったら見てください。

- 参考：[[Windows環境をいつでもリストアできるわがまま環境を作りたい]]

## ラン： 9 月のランは 5km

先月に引き続きランがおろそかになってますね。。

今月は台風だったり天気だったりいろんなものが重なって土日で走れないことが多かったです。

健康のためにも走りたいので週 1 で 5km を目標に走るというのをやめて、週 3 くらいで 1 回 1.5km くらいを細かく走るような感じでやり方を変えてやってみようと思います。

## テーブル設計のときにイミュータブルデータモデル

WEB+DB PRESS Vol.130 で「イミュータブルデータモデルで始める 実践データモデリング」という特集が組まれていて、同僚の人から結構良かったという声を聞きました。

自分もまだちゃんと読めていないのですが、実際の業務でも結構この話題が出てきてテーブル設計に反映した箇所などもあります。

著者の方が誰でも読めるように Scrapbox にまとめてくださっているのでちゃんと読まないとと思ってます。。

- 参考： [イミュータブルデータモデル \- kawasima](https://scrapbox.io/kawasima/%E3%82%A4%E3%83%9F%E3%83%A5%E3%83%BC%E3%82%BF%E3%83%96%E3%83%AB%E3%83%87%E3%83%BC%E3%82%BF%E3%83%A2%E3%83%87%E3%83%AB)

## Dyson V7 Mattress が欲しい

最近また鼻の調子が悪くて頭も痛くなって考えたりするのがつらい日が続いたりしてました。

少し前にアレルギー検査したときにダニアレルギーだったので、おそらく布団のダニが原因なのでアレルギーの原因を取り除けるものを調べていたら Dyson V7 Mattress がよさそうだなと思ったので、お金に余裕ができたら買いたい…

## Windows のセットアップ方法を git 管理

ソフトウェアインストールや[[AutoHotkey]]の設定ファイルなどを git 管理してとりあえずこのリポジトリ通りにセットアップすれば同じ Windows の環境を構築できるようになりました。まだまだスクリプト化できそうなところはありますが、いったんはこれでいいかなと思っています。

https://github.com/snyt45/windows11-dotfiles

## オブジェクト指向設計実践ガイド読書会

4.2 のパブリックインターフェースはテストするのところで、以前悩んだプライベートメソッドのテストをどうすべき問題について新たな気づきを得られました。
以前悩んだときは最終的にプライベートメソッドに対してテストを書かない選択を取りました。

- 参考： [[GraphQLのqueryのテストに仕様的な観点もどうしても書きたかった]]

ですが 4.2 を読んで改めて考えると、別クラス(例えば、計算クラス)のパブリックインターフェースとして切り出して、そのパブリックインターフェースをテストすればいいのかという気づきを得られました。

つまり、テストしたいプライベートメソッド(複雑なドメインロジックなどが含まれる)があるというのは、暗に別のオブジェクトが必要なことを示唆しているのだなと思えるようになりました。

## Graphql のエラーハンドリングの設計を頑張った

自社プロダクトでは、サーバーサイドで Graphql を使用しています。

今まで Graphql のエラーハンドリングについてちゃんと考えるタイミングがなかったのですが、自社でそのタイミングがあったので試行錯誤しながら次のような設計にしました。

- トップレベルの erros を使用する
- `GraphQL::Schema#rescue_from`の層は、あくまでセーフティーネットのため、発生した例外に対応した最低限の情報を返すところまでにとどめる。複雑な情報を返す必要がある場合などは各 mutation で正しく rescue する

このような設計にすることで次のメリットが得られました。

- Graphql のレールに乗っかれる(`GraphQL::Schema#rescue_from`など`GraphQL::ExecutionError`など使える)
- rescue_from 層は最後のセーフティーネット、mutation 層で想定される例外は正しく処理するという風に役割が明確になった

ほかにも細かいところだと、rescue_from 層をモジュール化してテストできるようにしたり、mutation 内で気軽に raise できるので save!が使えたりと見通しがよくなったりなどのメリットもありました。

元々は data 内の erros として返すという実装で進めていたのでかなり大きな変更ではありましたが、後々のことを考えるとつらくなりそうな感じはあったので、思い切って振り切ってよかったです。

## 作業環境を Dockerfile へ移行

先月の後半あたりで実際にプロダクト開発で作業環境は Docker 化して運用しています。

細かいところをあげると安定して作業できるまでにいろいろあったのですが、今はかなり安定して開発ができるようになってきて、思い切って作業環境の設定やインストールなどの諸々すべてを Dockerfile に移行してよかったなーと思ってます。

ただ、かなり大変だったのでほかの人にはおすすめはしません（笑）

## 仙台行ってました

仕事の関係で 9 月末は 3 日間ほど仙台に行ってきました。

仙台の美味しいものをたくさん食べたり、今取り組んでいるプロダクトの未来について話し合えたり、いつもはオンラインでやっている開発もオフラインで一緒に話しながら開発できたりとかなり有意義な時間でした。

また、1 年気合いを入れて頑張っていこう思います！
