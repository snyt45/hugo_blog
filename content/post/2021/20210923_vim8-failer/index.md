---
title: "Vim8のファイラー周りを充実させる"
description:
slug: "vim8-failer"
date: 2021-09-23T01:47:47+0000
lastmod: 2021-09-23T01:47:47+0000
image:
math:
draft: false
---

[前回](https://snyt45.com/posts/20210920/vim-plug/)、プラグイン管理をするためのプラグインを導入しました。

これでだいぶプラグイン管理がはかどるようになってきました。

次は、開発する際に欠かせない**ファイラー周りを充実させていこうと思います。**

## 今回入れるファイラーは Fern

ファイラーを調べてみたところ種類がたくさんありましたが、その中から**Fern を使うことにしました。**

Fern を選んだ理由は、次の 3 点です。

- 外部依存なし
- 「分割ウィンドウ」と「プロジェクトドロワー」の 2 つのスタイル
- プラグインで拡張可能

1 点目は、**依存関係がなくそのプラグインを入れるだけですぐに使えるというのは個人的には大きかったです。**  
依存関係が多いとセットアップ時の手順が多くなり大変なので依存関係がないというのは大きなメリットでした。

2 点目は、ファイラーを使うときのスタイルが 2 種類あるのも良かったです。  
[Fern の使い方](https://github.com/lambdalisue/fern.vim#usage)を見るとどんなものかわかると思います。  
個人的には「分割ウィンドウ」スタイルを使っていこうと思っています。

3 点目は、プラグインで機能拡張ができることです。  
あとでプラグインも追加していきますが、必要なものをプラグインで入れられるというのはとても便利です。  
[Fern のプラグイン一覧](https://github.com/topics/fern-vim-plugin)

## Fern のインストールと設定

vim-plug を使ってインストールするため、`vimrc`に下記を追加します。

`:PlugInstall`でプラグインをインストールしていきます。

```vimrc
call plug#begin('~/.vim/plugged')
Plug 'lambdalisue/fern.vim'
call plug#end()
```

これで`:Fern .`でファイラーが起動するようになります。

さらに`vimrc`に設定を追加します。  
隠しファイルの設定方法は[こちらの記事](https://zenn.dev/purenium/articles/50facb02e93cbd)を参考にしました。  
これで`Space+e`押下すると、Fern が起動するようになりました！

```vimrc
" <Leader>にSpaceキー割り当て
let mapleader = "\<Space>"
" 隠しファイルを表示する
let g:fern#default_hidden=1
" Fern .をSpace+eキーに置き換え
nnoremap <silent> <Leader>e :<C-u>Fern .<CR>
```

Fern を`Space+e`で開いているところ。

https://asciinema.org/a/6HJDlmoox6qOCQKXDb0x84ORq

## Fern のプラグインを追加

ざっとインストール方法と vimrc の設定、実際にどのようなことができるのかを紹介。

### fern-preview.vim

[yuki\-yano/fern\-preview\.vim: Add a file preview window to fern\.vim\.](https://github.com/yuki-yano/fern-preview.vim)

```vimrc
call plug#begin('~/.vim/plugged')
" Filer
Plug 'lambdalisue/fern.vim'
  Plug 'yuki-yano/fern-preview.vim' " 追加
call plug#end()

" 公式リポジトリを参考にキーマップを追加
function! s:fern_settings() abort
  nmap <silent> <buffer> p     <Plug>(fern-action-preview:toggle)
  nmap <silent> <buffer> <C-p> <Plug>(fern-action-preview:auto:toggle)
  nmap <silent> <buffer> <C-d> <Plug>(fern-action-preview:scroll:down:half)
  nmap <silent> <buffer> <C-u> <Plug>(fern-action-preview:scroll:up:half)
endfunction

augroup fern-settings
  autocmd!
  autocmd FileType fern call s:fern_settings()
augroup END
```

ファイラーを開いてて、ファイルにカーソルを合わせて`p`とするとプレビューがフローティングウィンドウで表示されるようになります。  
神プラグインです。  
`Ctrl+p`とすると、ファイルにカーソルが合うと自動でプレビューしてくれます。

https://asciinema.org/a/jpEntLeTDxBk4jeidIIcU4wbf

### fern-git-status.vim

[lambdalisue/fern\-git\-status\.vim: 🌿 Add Git status badge integration on file:// scheme on fern\.vim](https://github.com/lambdalisue/fern-git-status.vim)

```vimrc
call plug#begin('~/.vim/plugged')
" Filer
Plug 'lambdalisue/fern.vim'
  Plug 'yuki-yano/fern-preview.vim'
  Plug 'lambdalisue/fern-git-status.vim' " 追加
call plug#end()
```

ファイル毎に git ステータスを表示してくれるようになるので便利です。

https://asciinema.org/a/k8SlnBvatD0HO26HuyTJugxsk

### fern-hijack.vim

[lambdalisue/fern\-hijack\.vim: Make fern\.vim as a default file explorer instead of Netrw](https://github.com/lambdalisue/fern-hijack.vim)

```vimrc
call plug#begin('~/.vim/plugged')
" Filer
Plug 'lambdalisue/fern.vim'
  Plug 'yuki-yano/fern-preview.vim'
  Plug 'lambdalisue/fern-git-status.vim'
  Plug 'lambdalisue/fern-hijack.vim' " 追加
call plug#end()
```

`vi`として`Space+e`でファイラーを起動していましたが、このプラグインを入れると`vi .`でファイラーを起動することができるようになります。

https://asciinema.org/a/V43iyvXVXHzGZ5CcjF5BIwDHo

## Fern でよく使うコマンドまとめ

### fern.vim

基本的なファイル操作は網羅できているはず。  
`-`を使う事で複数選択してリネームだったり、削除などができるのでとても便利。  
コマンドが分からなくなったら help を見る。

| コマンド                | 用途                               |
| ----------------------- | ---------------------------------- |
| `Shift+?` or `a`→`help` | help 表示                          |
| `Shift+c`               | (ファイル or ディレクトリ)コピー   |
| `Shift+m`               | (ファイル or ディレクトリ)カット   |
| `Shift+p`               | (ファイル or ディレクトリ)ペースト |
| `-`                     | (ファイル or ディレクトリ)選択     |
| `Shift+n`               | ファイル新規作成                   |
| `Shift+k`               | ディレクトリ新規作成               |
| `Shift+r`               | (ファイル or ディレクトリ)リネーム |
| `a`→`remove`            | (ファイル or ディレクトリ)削除     |

### fern-preview.vim

| コマンド | 用途                                                   |
| -------- | ------------------------------------------------------ |
| `p`      | ファイルプレビュー                                     |
| `Ctrl+p` | 自動でファイルプレビュー                               |
| `Ctrl+d` | フローティングウィンドウ内のファイルをスクロールダウン |
| `Ctrl+u` | フローティングウィンドウ内のファイルをスクロールアップ |

### fern-hijack.vim

| コマンド | 用途                       |
| -------- | -------------------------- |
| `vi .`   | ターミナルから Fern を起動 |
