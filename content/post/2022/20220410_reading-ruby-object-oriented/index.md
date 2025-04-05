---
title: "[読書メモ]オブジェクト指向設計実践ガイド／2. 3 変更を歓迎するコードを書く"
description:
slug: "reading-ruby-object-oriented"
date: 2022-04-10T11:29:43+0900
lastmod: 2022-04-10T11:29:43+0900
image:
math:
draft: false
---

## 本

オブジェクト指向設計実践ガイド ～ Ruby でわかる 進化しつづける柔軟なアプリケーションの育て方

https://gihyo.jp/book/2016/978-4-7741-8361-9

## 2.3 章の要約

変更を歓迎するためのコードを書くためのテクニックが紹介されている

- インスタンス変数の隠蔽
  - インスタンス変数をラッパーメソッドで隠蔽することで、変更する必要が出てきたときにラッパーメソッドの 1 箇所のみ修正すればよくなる。
- データ構造の隠蔽
  - 複雑なデータ構造は[[Ruby]]の Struct クラスを使って隠蔽する
- メソッドを単一責任にする
  - メソッドに対しても、単一責任は有効。複数の責任を持つメソッドは分割する。

## データ構造を隠蔽する Struct クラスは便利そう

2.3 章の中でも便利そうだと思った Struct クラスについて深ぼってみる。

書籍で紹介されている例だは、data には下記のような二次元配列が入ってくる。
そのときに、色んなところでこの二次元配列の構造を知っていなきゃいけない実装になるため辛い。
じゃあどうするかということで Struct が使われていた。

data

```ruby
@data = [[622, 20], [622, 23], [559, 30], [559, 40]]
```

Struct

```ruby
Wheel = Struct.new(:rim, :tire)
def wheelify(data)
  data.collect {|cell|
    Wheel.new(cell[0], cell[1])}
end
```

wheelify した結果は、Wheel のインスタンスのリストが返る。
Struct を使うことで、構造に意味を持たせることができる。

```javascript
[#<struct Wheel rim=622, tire=20>,
 #<struct Wheel rim=622, tire=23>,
 #<struct Wheel rim=559, tire=30>,
 #<struct Wheel rim=559, tire=40>]
```

Wheel のインスタンスはそれぞれ、rim と tire という属性を持ちアクセスすることができるので`cell[0]`や`cell[1]`としていた箇所が`wheel.rim`や`wheel.tire`とすることで可読性があがりメンテしやすいコードになった！

```ruby
irb(main):001:0> Wheel = Struct.new(:rim, :tire)
=> Wheel
irb(main):002:0> wheel = Wheel.new
=> #<struct Wheel rim=nil, tire=nil>
irb(main):003:0> wheel.rim
=> nil
irb(main):004:0> wheel.tire
=> nil
```
