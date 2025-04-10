---
title: "「達人プログラマー ―熟達に向けたあなたの旅― 第2版」を読みました"
description:
slug: "tatsujin-programmer-reading"
date: 2022-03-20T15:16:18+0000
lastmod: 2022-03-20T15:16:18+0000
image:
math:
draft: false
---

## どうしたら長くコードを書いていられるか考えたときに浮かんだ本

ぼんやりと長くコードを書いていたいなという気持ちがあり、どうしたら長くコードを書いていられるか考えたたときに思い出したのがこの本です。
実は、1 年以上前に一度さらっと読んだのですがそのときは自分に難しい内容が多かったです。

{{< x user="snyt45" id="1330516659325571075" >}}

1 年以上経った今再度読んでみると今でも難しい内容はたくさんあったのですが **前より得られることが多く理解できる内容も増えた** 気がしました。定期的に読むといろんな気づきが得られるスルメ本だと思いました。

## 印象に残った章

### 第 1 章の達人の哲学の前書き

> 達人 プログラマー は、 眼 の 前 の 問題 を 考える だけで なく、 常に その 問題 をより 大きな コンテキスト で 捉え、 常に もの ごと の 大局 を 見据えよ う と する の です。

SRE チームと MTG をしていたとき、Datadog で何やら問題が発生していることに気づきました。少ない情報から問題解決に向けてその場で議論が始まり、少ない情報である程度の問題把握と影響範囲が大きいかどうかの判断までしていてすごいなと思いました。**小さな問題でも常にものごとを大局に見据えることを意識しようと思いました。**

### 1 　 あなた の 人生

> ソフトウェア開発という職種は、自らで統制できる経歴として上位に挙げられるもののはずです。そのスキルには需要があり、知識は国境を越えて通用し、遠隔地からでも作業できます。給料も悪くないため、自らが望めば何だってできるはずです。

初心は忘れがちですが、そんな初心を思い出させてくれます。エンジニアという職種は、自分の努力が仕事に反映されやすい職種だと実感しています。だからこそ、 **現状維持ではなく自分の手で現状を切り開いていこうという気持ちを思い出させてくれました。**

### 2 　 猫がソースコードを食べちゃった

> 他人 や 他 の 何 かを 非難 し たり 言い訳 を し たり し ては いけ ませ ん。 すべて の 問題 を ベンダー、 プログラミング 言語、 管理、 同僚 の せい に し ては いけ ませ ん。 彼ら の 一部 あるいは すべて が そういった 問題 に 一役 買っ て いる の かも しれ ませ ん が、 言い訳 する のでは なく、 ソリューション を 提供 する のは 他 なら ぬ「 あなた」 の 役割 なの です。

**すごく耳が痛い章です…** 何か問題が起きたときには逃げ出したくなりますが、ここではいい加減な言い訳よりも対策を用意しようと書いてあります。また、言い訳をしたくなったときはゴム製のアヒルちゃんにでも話してその弁解が筋が通っているのか確認しようとあります。 **言い訳したくなるときに自分の考えを一歩進めて建設的な議論をするためにもとてもいい教訓だと思いました。**

### 3 　 ソフトウェアのエントロピー

> 「割れた窓」（つまり悪い設計、誤った意思決定、質の低いコード）をそのままにしてはいけません。発見と同時にすべて修復してください。もし正しく修復するだけの時間がないのであれば、分かりやすいところにその旨を明示しておいてください。

エントロピーとは無秩序の度合いです。そして、エントロピーは次第に無秩序になっていくことが証明されているとのことです。これはソフトウェアにも同じことが言えるよという章でした。「割れ窓理論」は有名な話ですが、コードに関してもほんとに同じだなということを実感しています。 **実際の現場でもそうなのですが、スケジュールなどを理由に一度品質を落としてマージされたコードはほぼ後で修正するタイミングは来ません。** それはビジネス的な理由の方が優先されるからだと思います。 **発見と同時に対応できる・対応しやすい環境づくりというのは大事だなと思いました。**

### 6 　 あなたの知識ポートフォリオ

> 毎年 少なくとも 言語 を 1 つ 学習 する。 言語 が 異なる と、 同じ 問題 でも 違っ た 解決 方法 が 採用 さ れ ます。 いくつ かの 異なっ た アプローチ を 学習 すれ ば、 思考 に 幅 が 生まれ、 ぬかるみ に はまる 事態 を 避け られる よう になり ます。

**毎年 1 言語を学ぶというのは意外に盲点でした。**ここに書いてある通りで言語が変われば問題解決方法が変わったりするので、A という言語では難しかったものが B という言語では簡単に解決できるみたいなこともあるので意識して毎年 1 言語ずつ学んでいこうと思いました。今年はまずはしっかり土台を作りたいので Ruby をやります。

> 月 に 1 冊 の ペース で 技術 書 を 読む。 インターネット 上 には、 星 の 数 ほど 多く の 短い エッセイ と、 数 は 少ない もの の 信頼 性 の ある 情報 を 見かける こと が でき ます が、 もの ごと を 深く 理解 する には それなり の 分量 が ある 書籍 を 読む 必要 が あり ます。

**「月 に 1 冊 の ペース で 技術 書 を 読む」**と書かれていて、期間で〇冊を読むというよりは今はここが不足しているから読もう！という感じで不足していることに気づいたら読むという感じだったので、 **読むペース(期間)を意識していこうと思いました。** 早速、月に一度リマインダーをセットしました。

### 8 　 よい設計の本質

> 自分自身 に「 私 が 実行 し た もの ごと で、 システム は 変更 し やすく なっ た のか、 それとも 変更 し にくく なっ た のか？」 という こと を 意識的 に 自問 する 必要 が ある でしょ う。 ファイル を 保存 し た 時 に これ を 実行 し て ください。 テスト を 記述 し て いる 時 に これ を 実行 し て ください。

**よい設計=ETC(Easier To Change(変更をしやすくする))原則である**と書かれています。
そして、ETC 原則を意識するために自問してくださいとあり、とても大事な観点だと思いました。自分がコードを書いた後に「何か違和感があるな」というときはおそらく ETC 原則に反しているときだと思います。そして、そういう場合ほとんど自分では良い方法がわからないことが多いですが、迷ったときは **常に「簡単に変更できる」という選択肢を採用するのがよいみたいです。**

### 15 　 見積もり

> その プロジェクト が 今 まで やっ た こと の ない もの で あれ ば、 たいてい の 場合 その 見積もり は 正しく ない の です。

この章では **正確な見積もりをするための手法が紹介されていますが、今までやったことのないプロジェクトの場合は正しくない** とあります。これは本当にその通りだと思いました。その後に「象を食らう」という話がありますが、実際に 1 つ着手してみたらもっと正確な見積もりが出て、それを繰り返せば精度があがるよねという話があり面白かったです。ソフトウェアのような見積もりが難しい領域で見積もりを出さないといけなかったり、見積もりを依頼する立場の人に読んでもらいたい章だと思いました。

### 18 　 パワーエディット

> 真 の メリット は、 エディター に 熟達 する こと で、 編集 の 方法 について 意識 し なく ても 済む よう に なる こと です。 頭 の 中 で 何 かを 考える こと と、 エディター の バッファー 上 に 何 かを 表示 さ せる こと には 隔たり が あり ます。 頭 の 中 の 思考 を 淀み なく 流れる よう に すれ ば、 プログラミング に メリット が もたらさ れ ます（ 自動車 の 運転 方法 を 誰 かに 教え た 経験 が あれ ば、 あらゆる 運転 操作 を 考え ながら し なけれ ば なら ない 人 と、 無意識 の うち に 車 を 運転 する 熟練 者 の 違い を 考え て み て ください）。

編集作業の効率化の話のときにどのくらい時間が削減されるかという点に目が行きがちですが、ここではその本質について書かれています。私も[[Vim]]で普段の作業を最適化した設定にしたり、ブログもエディットしやすい[[Roam Research]]で書けるようにしたりと最適化していますが、これらはすべて **思考が途切れないようにするため** です。 **思考が途切れないことはプログラミングをするうえで大きなメリットがあることを実感している** のでこれからも熟達するために改善していこうと思います。

### 27 　 ヘッドライトを追い越そうとしない

> 常に 小さな 歩幅 で 少し ずつ 前 に 進む よう に 意識 し て ください。 そして フィードバック を 得 た 上 で、 先 に 進む 前 に 軌道 修正 を 加え て ください。 フィードバック の ペース を 制限 速度 だ と 考える の です。 歩幅 や タスク を「 あまりに も 大きな もの」 に し ては いけ ませ ん。

**作業完了までの見積もり、将来に向けた準備などは予測を見誤るとリスクを抱え込むことになるとあります。** 実際、自分の場合コードを書く際に拡張性を考えた実装にしようとするあまりに無駄に時間をかけすぎてしまったりすることがよくありました。やりすぎもよくなく、 **自分の見える範囲の状況を整理して現状に合った対応をしていくことを心がけていこうと思います。**

### 28 　 分離

> 結合 は 変更 の 敵 です。 結合 によって、 離れ た 場所 に ある 2 つ の もの ごと の 整合性 を 常に 取る 必要 が 生み出さ れ、 一方 を 変更 し た 際 に 必ず もう 一方 も 変更 し なけれ ば なら なく なる の です。

なんとなくこのコードは密結合しているぞ！みたいなのは直感で分かるようにはなってきたのですが、その言語化ができていませんでした。ですが、この文章のおかげで **結合の解像度がぐっとあがりました！**

> 変更 が 入る 可能性 の ある ソフトウェア を 設計 する 際 には、 まったく 逆 の アプローチ を 採り、 柔軟性 を 追求 する こと になり ます。 そして 柔軟性 を 実現 する には、 それぞれ の コンポーネント 間 の 結合 を できる 限り 減らす べき なの です。 また、 困っ た こと に 結合 は 伝染性 を 持っ て い ます。 A が B と C に 結合 し て おり、 B が M と N に 結合 し て おり、 C が X と Y に 結合 し て いる 場合、 A は 実際 の ところ B と C、 M、 N、 X、 Y に 結合 し て いる こと に なる の です。

**結合は伝染する** というのもこの文章のおかげで解像度があがりました！ **この領域の話は興味があるので個人的にこういった部分の知識の引き出しをもっと増やしたいと思いました。** まだ、さっと目を通しただけなのでもっと具体的な部分について読み込んでみようと思います。

### 31 　 インヘリタンス（ 相続） 税

> 3 つ の テクニック が あり、 その いずれ かを 使用 すれ ば 今後、 いっさい 継承 を 使わ なく ても 済む よう に なる はず です。

- インターフェース と プロトコル
- 委譲
- mixin と trait
  継承には問題があるということを「相続税」という言葉で比喩していて面白いです。まだ、なんとなく継承には問題があるんだなーというくらいの認識なので時間を見つけて深堀したい章です。

### 40 　 リファクタリング

> いつ リファクタリング を 行う べき なのか？ 1 年前 よりも、 あるいは 昨日 よりも、 さらに は 10 分 前 よりも よい 考え が 浮かん だ 時、 つまり 何 かを 学ん だ 時 が リファクタリング の 時 です。

この章も個人的に好きな章です！もっと具体的な手法についても書かれてて実際にリファクタリングしたい！となったときにまた読みます！

### 49 　 達人 の チーム

ここも達人のチームに対して網羅的にめっちゃ良いこと書いてあるので、読み返して意識したい章です！

### 51 　 達人 の スターター キット

> バグ 発見 時 以降、 どの よう な 場合 で あっ ても 例外 なく、 どんなに 些細 な もの で あっ ても、 どれ だけ 開発 者 が「 いや、 こんな 事 は もう 二度と 起こり ませ ん」 と 訴え た として も、 自動 化 さ れ た テスト の チェック 内容 を 修正 し て、 その 特定 の バグ を 検出 できる よう に する べき なの です。

ここも耳が痛い話です…できるだけバグが起きた際はテストを追加するよう意識しているものの急ぎで不具合対応だけしてテストは後回しになったりと結構言い訳をつけて漏れがちです…バグがもし再度発生したときにその調査時間は無駄ですからテストを追加するように意識していきたいです。

### 52 　 ユーザーを喜ばせる

> あなた の 肩書き は「 ソフトウェア 開発 者」 や「 ソフトウェア エンジニア」 と いっ た もの かも しれ ませ ん が、 実際 は「 問題 の 解決 者」 で ある べき なの です。 それ が 我々 の やる こと で あり、 達人 プログラマー の 本質 という わけ です。 我々 は 問題 を 解決 する の です。

問題が発生したときに、すぐにどういう解決方法(ライブラリ、類似記事)があるのかに目が向きがちで本当の問題は何なのかを考えていない場合があったりするので、 **問題の解決者であることを意識していきます！**

## まとめ

後半の章の紹介は難しい話も多くて駆け足気味の紹介になりました。ですが、それが今の自分が理解できている領域であるということだと思います。定期的に読むと理解が深まると思った章もあるので定期的に読もうと思いました。
