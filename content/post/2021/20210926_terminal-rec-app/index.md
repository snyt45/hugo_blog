---
title: "Windowsでターミナル操作とキーストロークを録画するならLICEcap+Key-n-Strokeの組み合わせがいい感じ"
description:
slug: "terminal-rec-app"
date: 2021-09-26T01:50:30+0000
lastmod: 2021-09-26T01:50:30+0000
image:
math:
draft: false
---

Vim に再入門しているのですが、記事を書くときに実演したものを紹介できたら良いなーと思いいい感じのものがないかなーと調べてやった良い組み合わせを見つけたので紹介していきたいと思います。

## 今回の目的

- キーストロークを表示しつつターミナル操作を録画したい

## 試してみて今回の用途に適さなかったもの

紹介する前にせっかくなので使ってみたものの今回の用途に適さなかったものもあげておきます。

### asciinema

[asciinema \- Record and share your terminal sessions, the right way](https://asciinema.org/)

結構昔から有名どころのようなので使ってみました。

一度入れさえしてしまえば、`asciinema rec`でターミナル操作を録画することができ`exit`で録画終了することができるようになります。

また、アカウント連携すればサービス上に録画したものをアップしてくれるので振返りたいときにも便利です。

サービス上から共有したり、ブログに埋め込んだりすることもできるのでブログ側の容量を考えなくて良い点からかなり使い心地はよかったのですが、キーストローク表示しつつ録画することができなかったのであきらめました。

ちなみに以下の記事では実際に asciinema を使用しています。

[Vim8 のファイラー周りを充実させる • Small Changes](https://snyt45.com/posts/20210923/vim8-failer/)

### Orakuin

[ORAKUIN キー入力・マウス操作視覚化\(可視化\)ツール](https://orakuin.eksd.jp/)

こちらはキーストローク表示する用でつかってみましたが、動作が微妙でした。

### KeyCastOW

[brookhong/KeyCastOW: keystroke visualizer for Windows, lets you easily display your keystrokes while recording screencasts\.](https://github.com/brookhong/KeyCastOW)

KeyCast というものが Mac であるのですが、そちらの Windows 版みたいなものです。

こちらも良いのですが、Windows で実行するときに WindowsDefender でトロイの木馬と間違えられて exe ファイルが削除されてしまうこともあり、ちょっと気になってしまったので使うのをあきらめました。

使うときに参考にした記事。

[【動画配信】キーボード入力内容を画面に表示する KeyCastOW \| ふるのーとさんのブログ](https://fullnoteblog.com/keycastow/)

### Captura

[Captura](https://mathewsachin.github.io/Captura/)

ついに見つけた！と思ったほどによかった Captura。

こちらの記事が参考になります。

[動画キャプチャソフト Captura の使い方 \| IT 業務で使えるプログラミングテクニック](https://kekaku.addisteria.com/wp/20190412153241#toc2)

Captura は録画機能だけではなく、キーストローク表示やマウス操作表示なども機能としてもっていて今回の目的がスムーズに実行できました。

ただ、**数秒の GIF なのに容量が 50MB くらいになってしまいました。**

ffmpeg を入れて、ffmpeg で形式を GIF にして品質や FPS をいじってみたのですが容量問題が解決されずあきらめました。

その問題がなければ神アプリでした。

また、GitHub のリポジトリを見に行くとアーカイブ？されており、開発も 2020 年から止まっているぽかったのもあります。

[MathewSachin/Captura: Capture Screen, Audio, Cursor, Mouse Clicks and Keystrokes](https://github.com/MathewSachin/Captura)

## 今回の目的なら最高の組み合わせを見つけた。

それが、**LICEcap + Key-n-Stroke の組み合わせ**です。

■LICEcap  
[Cockos Incorporated \| LICEcap](https://www.cockos.com/licecap/)

■Key-n-Stroke  
[Key\-n\-Stroke
](https://github.com/Phaiax/Key-n-Stroke)

LICEcap は昔からあるアプリで Windows で GIF 動画を録画するのに最適な選択肢です。  
こちらは前から知っていてよく使っていましたがシンプルで扱いやすいアプリです。  
**保存される GIF の容量は数百 KB 程度**で容量問題も解決しました。

次に Key-n-Stroke です。  
こちらはほんとにたまたま見つけたキーストローク表示のためアプリです。

Captura のタグの所に「keystrokes」というタグがあり、そこをクリックするとこのタグを付けているリポジトリ一覧が表示されるのですがそこから見つけました。

![Capturaのタグの所に「keystrokes」というタグ](Snipaste_2021-09-26_11-01-29.png)

![「keystrokes」タグがついたリポジトリ一覧](Snipaste_2021-09-26_11-02-35.png)

**私はキーストローク表示用で使っていますが、exe ファイルを落とすだけで使えてキーストローク表示、マウスカーソルハイライト表示、クリック表示も行うことができるミニマムで使い勝手の良いアプリです。**

↓Key-n-Stroke をいい感じに設定した後の設定画面
![Key-n-Strokeの設定](Snipaste_2021-09-26_11-11-04.png)

↓LICEcap + Key-n-Stroke の組み合わせで録画した GIF 動画。

本当に細かいことをいうと、`:`が`;`と表示されたりというのはありますがほんとに微々たることなのでそれを踏まえてもかなり良いアプリです。

## まとめ

Windows でキーストローク表示しながらターミナル操作を録画する方法が自分の中で良いものがなくて困っていたのですが、LICEcap + Key-n-Stroke の組み合わせは自信を持ってよいと思える組み合わせでした。

これで Vim の操作した GIF 動画を快適に作成することができます。
