---
title: "Ubuntu22.04でruby3.1.0以外をインストールするのに苦労した話"
description:
slug: "ubuntu-22-04-ruby-3-1-0-install"
date: 2022-08-28T00:15:15+0900
lastmod: 2022-08-28T00:15:15+0900
image:
math:
draft: false
---

## 経緯

Weneedfeed という gem を使おうと思いインストールして`weneedfeed build`を実行したところエラーが出て使えなかった。[[Ruby]]のバージョン 3.1 が最新すぎるので、もしかしたら対応していないのかもと思い、問題の切り分けのために`rbenv install 2.7.6`をしたらインストールできなかった。

[[WSL]]に[[Ubuntu22.04]]をインストールして使っているのですが調べていくと、[[Ubuntu22.04]]は[[Ruby]]の 3.1 しかサポートしていない模様でした。

- https://github.com/rbenv/ruby-build/discussions/1940#discussioncomment-2519546

## 対応したこと

下記を参考にしたら`rbenv install 2.7.6`が成功して[[Ruby]]の 2.7.6 を[[Ubuntu22.04]]にインストールすることができました。また、Weneedfeed も[[Ruby]]の 2.7.6 であれば動くことも確認できました。

https://github.com/rbenv/ruby-build/discussions/1940#discussioncomment-2663209

実際に実行したコマンド

```javascript
sudo apt install build-essential checkinstall zlib1g-dev

wget https://www.openssl.org/source/openssl-1.1.1q.tar.gz
tar xf openssl-1.1.1q.tar.gz

cd openssl-1.1.1q/
./config --prefix=/opt/openssl-1.1.1q --openssldir=/opt/openssl-1.1.1q shared zlib
make
make test
sudo make install

sudo rm -rf /opt/openssl-1.1.1q/certs
sudo ln -s /etc/ssl/certs /opt/openssl-1.1.1q

RUBY_CONFIGURE_OPTS=--with-openssl-dir=/opt/openssl-1.1.1q rbenv install 2.7.6
rbenv global 2.7.6
```
