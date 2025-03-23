---
title: "Spacemacsのキーバインドが快適すぎたので同じ仕組みをvim-which-keyで導入する"
description:
slug: "vim-which-key"
date: 2021-10-09T14:15:44+0000
lastmod: 2021-10-09T14:15:44+0000
image:
math:
draft: false
---

## 少しだけ余談

皆さんは Spacemacs を知っていますか？

[Spacemacs: Emacs advanced Kit focused on Evil](https://www.spacemacs.org/)

簡単に説明すると Vim の操作と Emacs の操作の良いとこどりをしたエディタです。  
似たところで SpaceVim というプロジェクトもあります。

元々 Vim を触っていて Emacs の org-mode なども触ってみたくて Spacemacs にも手を出したことがあります。

テキスト編集で普通に Vim のキーバインドが使えるし、Emacs の資産の org-mode という素晴らしいモードも使えてほんとに良いとこどりのエディタでした。

Spacemacs の実体は Emacs で、選りすぐりのプラグインや設定が施されたものが簡単に手に入るようになっているため、手順に従うだけですぐに使える状態の Emacs が手に入るような感覚でした。

MRU などもすでに搭載されていて設定しなくていいし、特に**スペースキーを活用したキーバインドが快適過ぎました。**

Vim や Emacs を使う上でキーバインドを覚えるという高いハードルを軽減してくれました。

**スペースキーを押すと、ポップアップで次のキーとそのキーを押すと何が起きるのかが書いてあるのでキーバインドを覚えずとも使えて最高な体験でした。**

Spacemacs は一時マウス操作とキー操作を組み合わせて快適に使えていたのですが、やはり設定を変えようとするハードルは高かったのと Spacemacs は GUI
で使っていたので WSL 上で使おうとするとマウス操作？がうまく使えずに断念しました。

## Vim にも vim-which-key があった

個人的に Spacemacs では Emacs の資産が使えるというのも大きかったですが、それ以上にスペースキーから始めるキーバインドが快適すぎたというのがあります。

Vim でもないかなーと思って探していたら見つけました。

[liuchengxu / vim\-which\-key：ポップアップにキーバインディングを表示する Vim プラグイン](https://github.com/liuchengxu/vim-which-key)

説明にありますが、Emacs から Vim に移植したものみたいです。

> vim-which-key は emacs-which-key を vim に移植したもので、利用可能なキーバインディングを ポップアップで表示します。

## 実演

最初に vim-which-key を入れるとこんな風になるよというデモです。

Spacemacs のときは最初から色々設定されていたのですが、vim-which-key は自分が設定したものだけ表示されてくれるのでメンテナンスは必要ですが、とても便利です！

GIF 動画では、スペースキーを押すと下にぴょこっとポップアップが出てきて、次に押せるボタンのキーバインドと説明が表示されます。

今はウィンドウの垂直分割、水平分割、Fern を開くコマンドを割り当てています。

![vim-which-keyデモ](vim-which-key.gif)

## 早速インストールする

プラグイン管理には vim-plug を使っています。

```vimrc
Plug 'liuchengxu/vim-which-key'
```

## 設定

ほんとにまだ最小限の設定しかしていないですが、プラグインを入れていくたびにメンテナンスしていこうと思います。

スペースキー + e に Fern のアクションを割り当てていたのですが、副作用が出たりする操作もありました。  
例えばペースト操作を行う際に同じファイルがあったら上書きするか、名前を変えるか入力を求めらるのですが、入力できなかったりなど。  
Fern はかなり使いやすく忘れても`?`などですぐヘルプ見れて困らないこともあり、一旦コメントアウトすることにしました。

```vimrc
" By default timeoutlen is 1000 ms
set timeoutlen=500

" Map leader to which_key
nnoremap <silent> <leader> :<C-u>WhichKey '<Space>'<CR>
vnoremap <silent> <leader> :<C-u>WhichKeyVisual '<Space>'<CR>

" Create map to add keys to
let g:which_key_map = {}

" Single mappings
let g:which_key_map['-'] = [ '<C-W>s'  , 'split below']
let g:which_key_map['v'] = [ '<C-W>v'  , 'split right']
let g:which_key_map['e'] = [ ':Fern .' , 'explorer open']

" e is for explorer
" let g:which_key_map.e = {
"     \ 'name' : '+explorer' ,
"     \ 'h' : ['<Plug>(fern-action-help)'                 , 'help'],
"     \ 'o' : [':Fern .'                                  , 'open'],
"     \ 'C' : ['<Plug>(fern-action-clipboard-copy)'       , 'copy'],
"     \ 'D' : ['<Plug>(fern-action-remove)'               , 'remove'],
"     \ 'K' : ['<Plug>(fern-action-new-dir)'              , 'new dir'],
"     \ 'N' : ['<Plug>(fern-action-new-file)'             , 'new file'],
"     \ 'P' : ['<Plug>(fern-action-clipboard-paste)'      , 'paste'],
"     \ 'R' : ['<Plug>(fern-action-rename)'               , 'rename'],
"     \ 'X' : ['<Plug>(fern-action-clipboard-move)'       , 'cut'],
"     \ }

" Not a fan of floating windows for this
let g:which_key_use_floating_win = 0

" Hide status line
augroup vim-which-key
  autocmd!
  autocmd FileType which_key set laststatus=0 noshowmode noruler
augroup END

" Register which key map
call which_key#register('<Space>', "g:which_key_map")
```

また、設定をする際に下記を参考にしました。

[fw/dotfiles \- \.config/nvim/keys/which\-key\.vim at 01b025e62ef5e28f1f14291a1bfe520a33d254aa \- dotfiles \- picture\-vision \- git service](https://git.picture-vision.com/fw/dotfiles/src/commit/01b025e62ef5e28f1f14291a1bfe520a33d254aa/.config/nvim/keys/which-key.vim)

## まとめ

Vim を使っているとプラグインと設定が増えていって数日経つと使わないキーバインドは忘れてしまって、結局使わなくなったりします。  
今回紹介した vim-which-key もメンテナンスは必要ですが、メンテナンスをしていれば**とりあえずスペースキーを押せば何があったけと探すことができるようになるのでとても良いプラグインです。**
