---
title: "[読書メモ]メタプログラミングRubyの4章ブロックについて復習"
description:
slug: "reading-meta-programing-ruby"
date: 2022-04-27T11:53:48+0900
lastmod: 2022-04-27T11:53:48+0900
image:
math:
draft: false
---

## 目的

- メタプログラミング Ruby の本を読みながらブロックや Proc や lambda などが出てきたときに、普段使わないのでどういう流れで処理をするのか忘れてしまう。自分の理解しやすい形で整理したチートシートみたいなものを作って、すぐに思い出せるようにする。

## ブロックの基本

- ブロックの書き方(2 種類)
  - 波かっこ
  - do...end
- 慣習
  - 一行で書ける場合は「波かっこ」を使い、複数行のときは「do...end」を使う慣習がある
- ブロックの実行
  - `yield`を使う
  - `yield`は任意の引数を渡すことができる。例だと、ブロックの`|x, y|`の部分に対応
- ブロックを yield で実行する例(「波かっこ」と「do...end」の書き方別)

  - ```ruby
    def a_method(a, b)
      puts a + yield(a, b)
    end

    # 波かっこ
    a_method(1, 2) {|x, y| x * y}
    #=> 3

    # do...end
    a_method(1, 2) do |x, y|
      x * y
    end
    #=> 3
    ```

- ブロックの有無の確認

  - `block_given?`を使う
  - ```ruby
    def a_method
      puts block_given?
    end

    a_method                #=> false
    a_method {|x, y| x * y} #=> true
    ```

- ブロックのスコープ

  - ブロックはブロックを定義した周辺の束縛を一緒に連れて行ってくれる
  - 下の例だと、ブロックと同じスコープの中に定義されている`x = "Hello"`をブロックが実行されるスコープ(my_method の中)のところまで運んでくれる。
  - ```ruby
    def my_method
      puts yield("world!!")
    end

    x = "Hello"
    my_method {|y| "#{x} #{y}"} #=> Hello world!!
    ```

  - ブロック実行時に`x = "Good Bay"`を渡そうとしても、ブロックからは`x = "Good Bay"`は見えないため、下記の場合の出力結果は`Hello world!!`となる
  - ```ruby
    def my_method
      x = "Good Bay" # ブロックからこのxは見えない
      puts yield("world!!")
    end

    x = "Hello"
    my_method {|y| "#{x} #{y}"} #=> Hello world!!
    ```

## Proc の基本

- Proc とは
  - **Proc は ブロックをオブジェクトにしたもの**
- ブロックを Proc に変換する方法

  - `Proc.new` と `lambda` を使う 2 種類がある。
  - ```ruby
    p1 = Proc.new {|x| p x}
    p p1.class #=> Proc

    p2 = lambda {|x| p x}
    p p2.class #=> Proc
    ```

  - `lambda` は以下のような書き方もできる
  - ```ruby
    p3 = ->(x) {p x} # p2と同じ意味
    p p3.class #=> Proc
    ```

- &修飾

  - &修飾を使う場面
    - メソッドに渡した ブロック を Proc オブジェクト に変換したいとき
    - メソッドに渡した Proc オブジェクト を ブロック に変換したいとき
  - ```ruby
    def math(a, b)
      yield(a, b)
    end

    def do_math(a, b, &operation)
      p operation.class #=> Proc
      math(a, b, &operation)
    end

    p do_math(2, 3) {|x, y| x * y} #=> 6
    ```

    - 1. do_math を実行したときに `{|x, y| x * y}` というブロックを渡している。
    - 2. do_math の引数列の最後に`&operation`としているので、 ブロック`{|x, y| x * y}` が Proc オブジェクトに変換される。
    - 3. math に Proc オブジェクトを渡すときに `&operation`としているので、Proc オブジェクトが ブロック`{|x, y| x * y}` に変換されて渡される。

- `Proc.new`で作る Proc と `lambda`で作る Proc の違い

  - どちらも同じ Proc オブジェクトだが、`Proc.new`で作る Proc オブジェクト と `lambda`で作る Proc オブジェクトは厳密には違いがある。(`lambda?`とすると、`lambda`で作られた Proc オブジェクトか確認できる)

    - ```ruby
      p1 = Proc.new {|x| p x}
      p p1.lambda? #=> false

      p2 = lambda {|x| p x}
      p p2.lambda? #=> true
      ```

  - `Proc.new` と `lambda` の比較
    - `lambda` のほうが直感的な挙動をするため、Rubyist の多くは`lambda` を使うとのこと
    - キーワード
      - Proc.new
        - lambda
    - return
      - Proc.call されたスコープで return する
        ※意図せずスコープを抜けてしまう可能性がある
        - ブロックの中で return する
    - 引数
      - Proc.call 時に引数が過剰な場合は切り落としてくれる。引数が不足している場合は nil を割り当ててくれる
        - Proc.call 時に引数の数が合わないと ArgumentError になる

## まとめ

- Proc と lambda はなんとなく別物だという認識だったが、書き方が違うだけでどちらも Proc オブジェクトを生成するという点は同じということを理解できたのは良かった。
