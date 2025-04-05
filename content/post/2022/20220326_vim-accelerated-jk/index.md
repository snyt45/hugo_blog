---
title: "Vimの縦移動を高速にするプラグインを入れました"
description:
slug: "vim-accelerated-jk"
date: 2022-03-26T11:08:44+0900
lastmod: 2022-03-26T11:08:44+0900
image:
math:
draft: false
---

[[Vim]]で縦移動はよく j/k を連打しているのですが、それも辛くなってきたので「accelerated-jk」というプラグインを入れました
https://github.com/rhysd/accelerated-jk

## インストール・設定

インストールは vim-plug を使っています。
公式の README の通り設定します。

```javascript
Plug 'rhysd/accelerated-jk'

" accelerated-jk shortcut
nmap j <Plug>(accelerated_jk_gj)
nmap k <Plug>(accelerated_jk_gk)
```

## 使い方

j/k を長押しすると良い感じに加速してくれるので重宝しています。
