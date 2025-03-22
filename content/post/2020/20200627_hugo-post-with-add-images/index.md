---
title: "Hugoの記事に画像を追加する方法"
description:
slug: "hugo-post-with-add-images"
date: 2020-06-27T14:52:11+0000
lastmod: 2020-06-27T14:52:11+0000
image:
math:
draft: false
---

Hugo には画像を管理する方法が 2 種類あるようです。

content フォルダ内で記事と画像をセットで管理する方法で管理してみます。

`hugo new posts/20200627/test_post/index.md`

上記の hugo new コマンドで作成される content 配下のディレクトリ構造です。

```
content
  └ posts
      └ 20200627
          └ test_post
              └ index.md
```

test_post 内にある index.md が記事になるので、画像パスを以下のように記述します。

`![代替テキスト](./image.jpg)`

この場合 test_post 内の image.jpg を指します。

あとは、test_post 内に image.jpg を置くだけです。
この状態でビルドして、アップすれば記事内に画像を貼ることができました。

```
content
  └ posts
      └ 20200627
          └ test_post.md
          └ images.jpg
```

この記事にも画像を貼ってみました ↓

![ロゴ](image.png)
