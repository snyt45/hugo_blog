---
title: "週刊ニュース Lv13（2023年2月11日～2023年2月17日）"
description:
slug: "weekly-news-lv-13"
date: 2023-02-18T01:49:36+0900
lastmod: 2023-02-18T01:49:36+0900
image:
math:
draft: false
---

## 2 月 11 日(土)

特になし

## 2 月 12 日(日)

Git コマンドの結果を視覚的に見れる「git-slim」

- https://gigazine.net/news/20230204-git-sim/
- `git-slim log`のように使うことができる
- 便利そうだけど、python、ffmpeg、manim、miktex と依存関係が多すぎる…

Chrome 拡張機能 履歴全文検索「Falcon」

- https://gigazine.net/news/20230208-falcon-history-search/
- アクセスしたページの本文を自動保存してくれる。
- 便利そうだけど、機密情報なども自動保存されていたりすると気にすることも増えるから見送り。

Go 言語で対戦シューティングゲームを作る６

- コードを移植してくるときに中途半端に関数に切り分けていたけど、期間が空くと思い出すのに時間がかかり辛くなってきた。
- Go や JS の可読性の高い書き方をまだ理解できていないのでいろんな人のコードを参考にしながら一からキレイにしようと思った。

## 2 月 13 日(月)

親知らずの炎症がつらい

- 親知らず周りに口内炎ができていて長引いているなと思って調べるとただの口内炎じゃなかったみたいです
  - https://www.ichikishika.com/drblog/archives/137
- 唾を飲み込むだけでも痛いのでかなり辛いのですが、今はだいぶ収まってきました。
- 親知らずは今まで悪さをしたことがなかったのですが、こういう炎症も起きたりするんですね。
- 何度も再発するようなら親知らずの抜歯も検討しよう。

Go 言語で対戦シューティングゲームを作る７

- この日は実装よりも開発環境周りが気になってしまいそちらの成果の方が多かったです；；でも、改善するのはやっぱり楽しいです。
  - vim の fold を使った zc、zo で開閉するとコードの見通しがよくなる
  - lazygit のアップデートが来ていて作業コンテナの build し直し
  - フォントサイズを小さくすると見える範囲のコードが増えて移動が減っていい感じ
  - LspHover のポップアップのスクロールが vim でもできるように設定した

## 2 月 14 日(火)

Sidekiq のことを少しだけ理解できた

- 開発環境で app コンテナと sidekiq コンテナは別々と構成のときに、perform_async したときに一切 app コンテナ側にログが残らないなと思っていたのですが、必要な引数を Redis に保存して sidekiq コンテナ側で実行しているんですね(ちゃんと調べていないので間違っているかも)

Go 言語で対戦シューティングゲームを作る８

- この日は他の人のコードを色々見ながら勉強しました
  - Go の Router について
    - A. router 用の関数を用意して`*gin.Engine`のポインタを受け取り関数の中でルーティングを設定([参考](https://github.com/Jrohy/trojan/blob/83d64c85dfe235602f67b59afcd2a2b07cb08831/web/web.go))
    - B. router 用の関数を用意して関数内で`gin.Default`してルーティングを設定して、`*gin.Engine`のポインタを返す([参考](https://github.com/fahruluzi/pos-mini/blob/86ba3474bdc4fccff06ef7c19c559894cad4c301/router.go))
    - 今回はプログラムの規模的に A は分けすぎて辛いので、B くらいが丁度よさそうでした。
  - Go 言語で別のファイルに関数を定義する方法
    - 他の人のコードを見ながら、どこからも import していないけど呼び出せる関数があるなとおもったら、同じ package 内の関数であれば別ファイルで定義した関数を import せずに使うことができるみたいでした。
    - 個人的には明示的に import するほうが好みなので別ファイルに別パッケージで切り出して明示的に import する方法を使おうと思いました。
  - Go の melody について
    - 専用の構造体を用意して、構造体にメソッドを生やすオブジェクト指向っぽい書き方([参考 1](https://github.com/AntoD3v/simplews_go/blob/951d05fc70f6d8c6e1ae93a93b79de6d00a922f0/handler.go), [参考 2](https://github.com/jysim3/go-game/blob/0df0eef9ab95f063fe7d0f6f68d0cbece529d395/controllers/joker.go))
    - Go にはクラスはありませんが、どちらもオブジェクト指向っぽい書き方でわかりやすいです。個人的には lock などが使われている応用的な参考 2 の使い方を参考にしてやってみようかなと思いました。

## 2 月 15 日(水)

before_destroy は最後に`thorw :abort`する必要がある

- https://jabba.cloud/20171114211512
- before_destroy で削除するときに特定の条件を満たしてなかったらエラーにしたいときに、最後に`thorw :abort`をつけないと後続の処理も行われ削除されてしまうようです。そのため、before_destroy で実行するメソッドの最後に`thorw :abort`を書く必要がありました。

## 2 月 16 日(木)

研鑽 Ruby が全 17 章読めるようになった！

- https://www.lambdanote.com/blogs/news/ruby-3
- 途中までしか読めなかった研鑽 Ruby がついに全部読めるようになったみたいです！
- 購入しただけで積んでいるのでいつか読む(きっと…)

mattn さん著の Go 本が出るみたいです！速攻ポチりました！

- https://twitter.com/mattn_jp/status/1626031935763156999?s=20

関連で呼ばれるときには自動で関連モデルを設定したい & 明示的に呼ぶときは指定した値を設定したいを両立させる

- 結論からいうと、transient を使うと両立させることができました。
  - https://qiita.com/joker1007/items/da63b8630351c1f3fe1d
- ```javascript
  FactoryBot.define do
    factory :training_program_environment_week do
      uuid { SecureRandom.uuid }
      start_at { '18:00' }
      end_at { '20:00' }
      training_program_environment

      transient do
        _week_id { Week.ids.sample }
      end

      before(:create) do |training_program_environment_week, evaluator|
        training_program_environment_week.week_id = evaluator._week_id
      end

      trait :with_week do
        before(:create) do |training_program_environment_week, evaluator|
          training_program_environment_week.week_id = evaluator._week_id
        end
      end
    end
  end
  ```

- 下記のように何も指定しないときは、`before(:create)`でランダムな曜日が設定され、trait を指定して、\_week_id を渡したときは曜日を設定できました。transient で指定するのは仮想的な属性らしいのでモデルに存在する属性名と被らないように`_week_id`としました。
- ```javascript
  $ FactoryBot.create(:training_program_environment_week)
  #=> デフォルトでweekがランダムで設定される

  $ FactoryBot.create(:training_program_environment_week, :with_week)
  #=> デフォルトでweekがランダムで設定される（上記と同じ）

  $ FactoryBot.create(:training_program_environment_week, :with_week, _week_id: 5)
  #=> _week_idで指定した曜日で設定できる
  ```

## 2 月 17 日(金)

コードレビューをもっと楽にしたい

- https://tech.excite.co.jp/entry/2021/09/07/120000
- 今は GitHub 上で`.`で Visual Studio Code を起動することができますが、その Visual Studio Code 上でレビューができるようでした。
- また、ローカルでも同じことができその場合は拡張機能「GitHub Pull Requests and Issues」を導入すれば同じことができました。
- ただ、間違った操作をしそう間が否めないのでやはり GitHub 上で見るのが自分はよさそうです。
- そのときに差分が多かったりすると、GitHub はファイル単位での Viewed しかないため、ファイルの差分が大きすぎるとどこまで見たかがわからなくなってしまいます。
- そのときに便利なのが Chrome 拡張の「Super Simple Highlighter」です。見た箇所にハイライトをつけられます。おすすめはちょっと opacity を下げた gray がおすすめです。間違って画面を再リロードしてもハイライト箇所は残ってくれるので誤操作でどこまで見たっけという不幸をなくすことができます。
  - https://chrome.google.com/webstore/detail/super-simple-highlighter/hhlhjgianpocpoppaiihmlpgcoehlhio
- さらに便利だと思ったのが Chrome 拡張の「どこでもメモ」です。PR にコメントするまではないけど自分用で一旦コメントを残したいときに重宝します。こちらも自分で消さない限りは画面を再リロードしてもメモは残るというのが良いです。
  - https://chrome.google.com/webstore/detail/memo-anywhere/fjfoncfdjhdefjhknbaphionnognbnpl?hl=ja
- GitHub が行単位で見た箇所をハイライトできるといいのですが、その機能はないので一旦は Chrome 拡張を使うと良さそうでした。
