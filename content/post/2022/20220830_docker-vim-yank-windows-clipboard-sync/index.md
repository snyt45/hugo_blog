---
title: "DockerコンテナのVimでヤンクした内容をWindowsホストのクリップボードへ共有する方法"
description:
slug: "docker-vim-yank-windows-clipboard-sync"
date: 2022-08-30T00:26:32+0900
lastmod: 2022-08-30T00:26:32+0900
image:
math:
draft: false
---

Docker コンテナ上の Vim でヤンクした内容を Windows ホストのクリップボードへ共有する方法がなかなか見つからず苦戦したのですが、やっと参考になる記事を見つけました。

参考： https://stuartleeks.com/posts/vscode-devcontainer-clipboard-forwarding/

参考記事では`socat`を使います。`socat`を初めて知ったのですが、TCP コネクションで待ち受けたり、TCP コネクションで通信したりできるようです。うまく動くようになったときにやったことを残しておきます。

## WSL 側の対応

ホストの WSL 側では`socat`でヤンクした内容を TCP コネクションで待ち受ける必要があるため、WSL に`sudo apt install socat`で`socat`をインストールします。

次に、`~/.bashrc`に次の内容を追記します。Windows の WSL 環境では、`echo 'hello world' | clip.exe`で Windows のクリップボードにデータを送信できますが、ここでも同じように`clip.exe`に受け取ったデータを送信するようです。

bashrc

```javascript
  if [[ $(command -v socat > /dev/null; echo $?) == 0 ]]; then
      # Start up the socat forwarder to clip.exe
      ALREADY_RUNNING=$(ps -auxww | grep -q "[l]isten:8121"; echo $?)
      if [[ $ALREADY_RUNNING != "0" ]]; then
          echo "Starting clipboard relay..."
          (setsid socat tcp-listen:8121,fork,bind=0.0.0.0 EXEC:'clip.exe' &) > /dev/null 2>&1
      else
          echo "Clipboard relay already running"
      fi
  fi
```

以降、WSL のターミナルを開くたびに`socat`で TCP コネクションを待ち受けるようになります。

- ポート番号は任意ですが参考記事と一緒にしています。

## Docker 側の対応

Docker 側でも`socat`を使うので`sudo apt install socat`でインストールします。

次に、`socat`の TCP コネクションに送信するための`clip.sh`ファイルを作成します。
`echo "hello from clip.sh" | clip.sh -i`のような使い方をします。この時点でホストの WSL の`socat`にデータが送られて Windows のクリップボードにコピーされます。

clip.sh

```javascript
  #!/bin/bash
  for i in "$@"
  do
    case "$i" in
    (-i|--input|-in)
      tee <&0 | socat - tcp:host.docker.internal:8121
      exit 0
      ;;
    esac
  done
```

vimrc は下記設定を追加します。ヤンクしたときに先ほどの`clip.sh`にデータを送るので、それがホストの WSL の`socat`にデータが送られて Windows のクリップボードにコピーされます。

vimrc

```javascript
" ヤンクした内容をクリップボードにコピー
augroup Yank
  au!
  autocmd TextYankPost * :call system('clip.sh -i', @")
augroup END
```

これで念願の『Docker コンテナの Vim でヤンクした内容を Windows ホストのクリップボードへ共有する』ことができました。記事の作者様に感謝します。
