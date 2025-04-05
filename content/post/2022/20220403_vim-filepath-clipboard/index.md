---
title: "Vimでカレントファイルのパスをクリップボードに渡したい"
description:
slug: "vim-filepath-clipboard"
date: 2022-04-03T11:21:43+0900
lastmod: 2022-04-03T11:21:43+0900
image:
math:
draft: false
---

## 結論

`SPC + C-g`すると、ファイルパスを[[Windows]]のクリップボードにコピーするようにしました。
最初は無名レジスタの指定がうまくいかずハマりましたが、`@"`でできました。
これだと絶対パスになるので、[[Visual Studio Code]]のようにファイルのルートからの相対パスでファイルパスを取得できるようにしたいです。

- `@"=expand('%:p')`
  - 無名レジスタに`expand('%:p')`でカレントファイルの絶対パスを保存
- `call system('clip.exe', @")`
  - 無名レジスタの内容を[[Windows]]のクリップボードに渡す

```javascript
" カレントバッファのファイルパスをクリップボードにコピー
nnoremap <leader><C-g> :<C-u>echo "copied fullpath: " . expand('%:p') \| let @"=expand('%:p') \| call system('clip.exe', @")<CR>
```

## 参考

[Emacs/Vim で、現在編集中のファイルフルパスをクリップボードにコピーする \| intothelambda](https://intothelambda.com/blog/copy-fullpath-using-emacs-and-vim/)

[【vim めも】 3\. レジスタ \- Qiita](https://qiita.com/r12tkmt/items/97afb4b489966e746b20)
