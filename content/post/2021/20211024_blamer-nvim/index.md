---
title: "git blameができる拡張機能が欲しかったのでblamer.nvimを入れてみた"
description:
slug: "blamer-nvim"
date: 2021-10-24T14:18:28+0000
lastmod: 2021-10-24T14:18:28+0000
image:
math:
draft: false
---

ファイルごとに git blame ができる拡張機能を探していたところ、下記記事をドンピシャで見つけたので入れてみました。

[ポップアップウィンドウで git blame を確認できる blamer\.nvim \- Qiita](https://qiita.com/Yoika/items/26553e8ad067b9e468e8)

blamer.nvim という名前ですが、popup 機能が使える最新の Vim であれば使うことができます。

## git blame とは

> git blame の基本的な機能は、ファイルでコミットされた特定の行の作成者メタデータを表示することです。  
> [git blame \| Atlassian Git Tutorial](https://www.atlassian.com/ja/git/tutorials/inspecting-a-repository/git-blame)

## インストール方法

[APZelos/blamer\.nvim: A git blame plugin for neovim inspired by VS Code's GitLens plugin](https://github.com/APZelos/blamer.nvim#installation)

プラグイン管理には vim-plug を使っています。  
vimrc に下記を追加して、`:PlugInstall`します。

```vimrc
Plug 'APZelos/blamer.nvim'
```

## 設定

私は vimrc に次の設定をしました。

```vimrc
" By default blamer_delay is 1000 ms
let g:blamer_delay = 500

let g:blamer_date_format = '%y/%m/%d'
```

また、`SPC`キーを起点としたキーマッピングで使えるように vim-which-key の設定も行っています。

`SPC` + `g` + `b`で`:BlamerToggle`を実行します。

```vimrc
" g is for git
let g:which_key_map.g = {
      \ 'name' : '+git' ,
      \ 'b' : [':BlamerToggle'      , 'git blame toggle'],
      \ }
```

## デモ

`:BlamerToggle`をすると、ノーマルモードで今いる行の git のメタデータが表示されるようになります。

また、`v`でビジュアルモードに切り替えて選択した複数行の git のメタデータも表示されます。

非常にシンプルな機能になっています。

![demo](blamer-nvim.gif)

## まとめ

有名どころの[fugitive.vim](https://github.com/tpope/vim-fugitive)の機能の中に`:Git blame`という機能もありますが、  
git blame の機能のみが欲しかったためドンピシャで git blame 専用のプラグインが見つかって良かったです。
