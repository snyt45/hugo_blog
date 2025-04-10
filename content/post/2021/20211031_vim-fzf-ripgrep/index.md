---
title: "fzf + ripgrepをVim連携させた"
description:
slug: "vim-fzf-ripgrep"
date: 2021-10-31T14:26:18+0000
lastmod: 2021-10-31T14:26:18+0000
image:
math:
draft: false
---

[fzf と ripgrep を vim 連携させて優勝する \| 雑司ヶ谷インターネット](https://zoshigayan.net/ripgrep-and-fzf-with-vim/)という記事を見てからずーっと優勝したいと思っていました。

ある程度 Vim の設定がいい感じになってきて優勝する準備ができたので設定してみました。

## fzf と ripgrep をインストールする

まず、fzf をインストールしていきます。

```
brew install fzf
```

fzf をインストールすると下記設定をしてくださいと言われます。

```
To install useful keybindings and fuzzy completion:
  /home/linuxbrew/.linuxbrew/opt/fzf/install

To use fzf in Vim, add the following line to your .vimrc:
  set rtp+=/home/linuxbrew/.linuxbrew/opt/fzf
```

言われた通りに`/home/linuxbrew/.linuxbrew/opt/fzf/install`を実行していきます。

```
❯ /home/linuxbrew/.linuxbrew/opt/fzf/install
Downloading bin/fzf ...
  - Already exists
  - Checking fzf executable ... 0.27.3
Do you want to enable fuzzy auto-completion? ([y]/n) y
Do you want to enable key bindings? ([y]/n) y

Generate /home/snyt45/.fzf.bash ... OK
Update fish_user_paths ... Failed
Symlink /home/snyt45/.config/fish/functions/fzf_key_bindings.fish ... OK

Do you want to update your shell configuration files? ([y]/n) y

Update /home/snyt45/.bashrc:
  - [ -f ~/.fzf.bash ] && source ~/.fzf.bash
    + Added

Create /home/snyt45/.config/fish/functions/fish_user_key_bindings.fish:
    function fish_user_key_bindings
      fzf_key_bindings
    end

Finished. Restart your shell or reload config file.
   source ~/.bashrc  # bash
   fzf_key_bindings  # fish

Use uninstall script to remove fzf.

For more information, see: https://github.com/junegunn/fzf
```

ざっくりと次のような設定がされている気配がありました。  
(余裕があればそのうちちゃんと調べたい)

- ファジーオートコンプリートを有効にする Y
- キーバインディングを有効にする Y
  - ~/.fzf.bash が作成される (たぶん、bash でのキーバインドが追加される？)
  - ~/.config/fish/functions/fzf_key_bindings.fish が作成される(たぶん、fish でのキーバインドが追加される？)
- シェルの設定ファイルを更新する Y
  - ~/.bashrc が更新される
    - bashrc 読み込み時に source ~/.fzf.bash している。
  - fish の設定が作成される
    - ~/.config/fish/functions/fish_user_key_bindings.fish
      - fzf_key_bindings を読み込んでいるっぽい

この設定がされた後は、ターミナル上で下記キーバインドが使えるようになります。

| キーバインド | 内容                                                                                                                         |
| ------------ | ---------------------------------------------------------------------------------------------------------------------------- |
| `C-r`        | コマンド履歴の絞り込み。選択したコマンドをコマンドラインに貼り付け                                                           |
| `Alt-c`      | 今いるディレクトリ配下のすべてのディレクトリから絞り込み。選択したディレクトリに cd する                                     |
| `C-t`        | 今いるディレクトリ配下の全てのファイル・ディレクトリから絞り込み。選択したファイル・ディレクトリ名をコマンドラインに貼り付け |

続いて、ripgrep もインストールします。

```
brew install ripgrep
```

続いて、vim 上で fzf のコマンドが使えるようにするために vim 用の fzf プラグインを入れます。

```
" fuzzy finder
Plug 'junegunn/fzf.vim' " Use fzf installed with linuxbrew
```

続いて、fzf.vim から ripgrep を使うための設定を施します。

fzf 本体は linuxbrew でインストールしたものを使うように指定しています。  
`:RG`コマンドを実行したときの挙動を設定しています。

```vimrc
" Use fzf installed with linuxbrew
set rtp+=/home/linuxbrew/.linuxbrew/opt/fzf

" ripgrep
" https://zoshigayan.net/ripgrep-and-fzf-with-vim/
if executable('rg')
  function! FZGrep(query, fullscreen)
    " --hidden 隠しファイルも隠しディレクトリも含める
    " --follow シンボリックリンクも含める
    " --glob   対象ファイルのファイルパターンを指定
    let command_fmt = 'rg --column --line-number --no-heading --hidden --follow --glob "!.git/*" --color=always --smart-case -- %s || true'
    let initial_command = printf(command_fmt, shellescape(a:query))
    let reload_command = printf(command_fmt, '{q}')
    let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
    call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
  endfunction

  " RGマンドを定義。同名コマンドが定義されていた場合上書きする
  " RGコマンドはFZGrep関数を呼び出す
  command! -nargs=* -bang RG call FZGrep(<q-args>, <bang>0)
endif
```

また、vim-which-key のキー割り当ても設定しています。

```vimrc
" , is for fzf
let g:which_key_map[','] = {
      \ 'name' : '+fzf' ,
      \ 'b' : [':Buffers' , 'Open buffers'],
      \ 'p' : [':GFiles'  , 'Git files (git ls-files)'],
      \ 'P' : [':Files'   , 'Files'],
      \ 's' : [':RG'      , 'rg search result'],
      \ 'c' : [':Commits' , 'Git commits'],
      \ }
```

## bat をインストールする

fzf で検索したときに bat を入れる前だとコードに色がついていないのですが、  
bat を入れるだけでコードに色がつくようになるので入れておきます。

```
brew install bat
```

## fzf + ripgrep で優勝しているデモ

ターミナル上で`C-r`でコマンド履歴で検索しているところ
![demo1](fzf-c-r.gif)

Vim 上で`SPC`+`,`+`c`でコミットメッセージで検索しているところ
![demo2](fzf-commits.gif)

Vim 上で`SPC`+`,`+`p`でファイル名で検索して、ファイルを開いているところ
![demo3](fzf-gfiles.gif)

Vim 上で`SPC`+`,`+`s`でソースコード全文検索して、ファイルを開いているところ
![demo4](fzf-rg.gif)

## まとめ

冒頭で紹介した記事を見てからずっとやりたかった設定で、実際に設定をしてみると、  
かなり高速で遅さは全く感じずに探したいファイルを見つけることができるようになったので導入して良かったです。
