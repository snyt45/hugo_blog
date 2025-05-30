---
title: "週刊ニュース Lv1（2022年11月14日～2022年11月18日）"
description:
slug: "weekly-news-lv-1"
date: 2022-11-19T01:08:35+0900
lastmod: 2022-11-19T01:08:35+0900
image:
math:
draft: false
---

記念すべき週刊ニュース１回目。

ここでは、RoamResearch のデイリーノートでフリーライティングしたものや作業のメモの中から公開できそうなものを適当にピックアップして箇条書きではなく文章で書くことを意識しようと思います。

思考しながら書くことが多いため、内容はそのメモをちょっとだけ整えたレベルになるかと思います。

## 11/14(月)

最近アトミックノートという概念を知り、使い捨てメモとアトミックノートをどう活用していくべきかということを考えていました。というのも、二クラス・ルーマンという人が作った Zettelkasten というメモ取りのためのシステムについて学び RoamResearch で運用するための仕組みまで構築したもののその仕組みに乗ろうとすると、書く前に考えてしまい書けなくなるということがあったからです。書く量が減ってしまうと頭の中で思考が進まないのでとにかく書くためのハードルを限りなくしつつ、アトミックノートも作成しつつ一つずつ自分の知識を積み上げていくためのいいところどりの仕組みを考えているところです。

また、チームギークという本を読んだのですが、自分自身が HRT 原則を実践できていない出来事がありました。HRT 原則とは他人とうまくやるための Hack で、謙虚・尊敬・信頼の英語の頭文字を取ったものです。そのときは、自分たちのことを考えてくれた相手に対してリスペクトがない言葉使いをしてしまったので、少しずつ意識し改善中です。

## 11/15(火)

この日はアトミックノートにしたいものをひたすらあげていき、何をアトミックノートにすべきだとか、あのノートもアトミックノートにできそうだとかを考えていました。どの粒度でどの程度まとめるかにもよりますが、ほとんどのものはアトミックノートにできそうだと思いました。例えば、その日 RoamResearch で block embed という機能の良さに改めて気づいたのですが、いつもだと、よく使うチートシートなどにトリガーとなるように block embed について書いておくのですが、これもアトミックノートとして書いておくとただのメモよりは使い回しが効くようになりますし、何よりいつもだとコピペレベルでしかまとめないところをアトミックノートにするためには一つのことだけについて書く必要があるので記憶の定着もよさそうなどと思ったのでした。

## 11/16(水)

自社サービスを開発する会社で働いているのですが、まだまだサービスとしてはシステムもリリース前の開発段階で今は MVP で検証した価値を与えられる仕組みを別のツールなどを使ってユーザーに届けている段階なのですが、価値を感じてお金を払い続けているユーザーがいるという気づきを BizDev チームから共有してもらいました。

この話を聞いて思い出したのは、Inkdrop の作者の方のお話です。この記事を受けて、1000 人が熱狂できるサービスを個人で作りたいと思っていた時期が懐かしいです笑 いま 1 人のユーザーが熱狂してくれています。この熱狂は周囲の人達に伝播して、また熱狂するユーザーを 1 人また一人と連れてくれてきてくれることを願っています。

> 個人としてその中で生き残るには、ニッチの領域で自分の価値観を大事にして、それに共感してくれる人を集めることが一つの方法だと思います。幸いにも継続課金モデルがウェブサービス以外のアプリでも受け入れられつつあります。それは大量のユーザを無理に集めなくてもビジネスが継続して成立する可能性を示しています。ネットによって広告に頼らなくても影響力が得られるようになった今、1000 人のファンを集めることは大変ですが不可能ではないでしょう。

参考：[Markdown ノートアプリ Inkdrop で家賃の半分が賄えるようになりました](https://blog.craftz.dog/inkdrop%E3%81%A7%E5%AE%B6%E8%B3%83%E3%81%AE%E5%8D%8A%E5%88%86%E3%81%8C%E8%B3%84%E3%81%88%E3%82%8B%E3%82%88%E3%81%86%E3%81%AB%E3%81%AA%E3%82%8A%E3%81%BE%E3%81%97%E3%81%9F-3f30f4e1e479)

## 11/17(木)

ある会議で実装中の機能のパフォーマンスについて検討していることを話してくれるエンジニアに対して、リスペクトがない回答をしているのを間近で観測しました。最近チームギークを読んでいるので、こういうのを観測すると何とも言えない気持ちになります。白か黒かで言うことは簡単ですがその前に早いうちから最適化について検討したという素晴らしい事実についてまずはリスペクトがあるといいなと思いました。常に HRT 原則を忘れないようにしていきたいですね。

## 11/18(金)

この日はとても素晴らしい日でした。最近よく Vim がクラッシュしてしまい Vim の思考の速度で開発するという開発体験が最悪の開発体験になっていたのですが、原因が排除できて最高の開発体験が戻ってきたからです。原因は Vim ではなく、Windows Terminal + MicrosoftIME の相性が悪かったようです。今は Google 日本語入力を使うことで回避できました。

また、久しぶりに SQL を書きました。親レコードに子レコードが複数紐づくことがあるという 1 対多のテーブルがあり、子レコードは複数の type を持っています。やりたいのは A という type のみを持っている親レコードだけを取得したいです。でも 1 対多のテーブルのため、A だけで絞り込みをかけると、A と B も持っていた場合にも該当しています。そのため、EXISTS でサブクエリを使い、サブクエリで親の id で GROUP BY して A のカウントが 1 かつ A の以外のカウントが 0 という条件で絞り込むことでやりたいことを達成しました。とりあえず動くコードは書けたのですが、サブクエリはパフォーマンスが悪いときもあったり、あとは、サブクエリで関連テーブルを SELECT するときはなぜか JOIN しなくても動くなどよくわかっていないところもあるので、もっと SQL 知りたいと思いました。
