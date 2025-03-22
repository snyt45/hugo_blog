---
title: "たった1日で基本が身に付く！ Go言語 超入門@4日目"
description:
slug: "1day-go-4days"
date: 2020-11-26T16:25:56+0000
lastmod: 2020-11-26T16:25:56+0000
image:
math:
draft: false
---

[たった 1 日で基本が身に付く！ Go 言語 超入門：書籍案内｜技術評論社](https://gihyo.jp/book/2020/978-4-297-11617-0)

もう 4 日目に突入してしまいました。

1 章 1 時間計算で 8 章あるので 8 時間。

1 日でいけるかなーと思っていましたが、一気には無理でしたね。

今日も少しずつ進めていこうと思います。

## CHAPTER 6 　データを直接指し示すポインタ

### 変数に変数を代入する

ポインタの前に、以下の場合を見ていく

```
a := 5
b := a
a = 7

fmt.Println(a) // 7
fmt.Println(b) // 5
```

- b に a を代入したあとに、a に 7 を代入している。
- でも b は 5 のままで変わっていないことがわかる。

### メモリの位置(アドレス)を呼び出す

- 次にメモリの位置を見ていく。
- **変数の前に「&」をつけると、メモリの場所を呼び出せる**
- Printf 関数でポインタを表す「%p」を使う

```
a := 5
b := a
a = 7

fmt.Println(a) // 7
fmt.Println(b) // 5

fmt.Printf("aのメモリの位置：%p\n", &a) // aのメモリの位置：0xc0000140a0
fmt.Printf("bのメモリの位置：%p\n", &b) // bのメモリの位置：0xc0000140a8
```

- a と b では値の保存場所が違うことが確認できる。
- 変数に変数を代入しても別の場所に保存されるため、安心して使うことができる。

### アドレスから値を呼び出す

- **アドレスから値を呼び出すには、アドレスの前に「\*」を付けます。**

```
a := 5
b := &a

fmt.Printf("bの値：%p\n", b) // bの値：0xc0000140a0
fmt.Printf("aのアドレス：%p\n", &a) // aのアドレス：0xc0000140a0

// aのアドレスとbの値は同じ
// ではbから値を呼び出すには？

fmt.Printf("bの値：%d\n", *b) // 5
```

- `*[アドレスの入った変数]`でポインタ表現

### アドレスを使って書き換える

- 変数 a
- 変数 b は、a のアドレス
- \*b = 7 で a のアドレスの値を変更する。
- 変数 a と変数 b は同じアドレスをみているので、どちらも同じ 7 になる。

```
a := 5
b := &a

*b = 7

fmt.Printf("aの値：%d\n", a)  // 7
fmt.Printf("bの値：%d\n", *b) // 7
```

- 異なる変数から同じ値を操作できるという点で有用
- 「変数がどのアドレスを見ているか」と「どのポインタ表現(\*hoge)に対して値を代入したか」に注目すると個人的には混乱しにくかった。

- ちょっと勘違いしていたが下記で良い気づきが得られた。**あくまでもアドレスを代入する変数は値としてアドレスを持つだけで、変数自身のアドレスは別である。**

```
inta := 5
adinta := &inta
bdinta := &inta
*bdinta = 9

fmt.Printf("inta のアドレスは %p\n", &inta)     // inta のアドレスは 0xc0000140a0
fmt.Printf("adinta のアドレスは %p\n", &adinta) // adinta のアドレスは 0xc000006028
fmt.Printf("bdinta のアドレスは %p\n", &bdinta  // bdinta のアドレスは 0xc000006030
```

### クロージャの謎

- 4 章で出てきたクロージャの謎もなんで同じ ctr 変数を使いまわし続けられるのかがやっとわかった！
- ちゃんとしたことまでは分かっていないけど、一回目に counter 実行後の返り値である無名関数の中で ctr は有効のままなので、再度呼び出すときにもメモリの同じ位置を書き換えてくれる。
- でも、クロージャでなくてもポインタでも同じことできそう。

```
package main

import "fmt"

func counter() func() {
  ctr := 0 // ① 変数ctrを宣言。メモリ上に場所を確保
  fmt.Println("カウンタを初期化しました")
  fmt.Printf("カウンタのアドレスは%p\n", &ctr)

  return func() {
    ctr++ // ② ①で確保したメモリの場所に値を保存
    fmt.Printf("カウンタの値は%d、", ctr)
    fmt.Printf("カウンタのアドレスは%p\n", &ctr)
	}
}

func main() {
	countfnc := counter() // ③ counterを実行すると①、②が実行される。戻り値の無名関数がcountfncに代入。
	countfnc() // ④countfnc内では①で宣言したctrが有効なのでカウントアップできる。以降同じ
	countfnc()
	countfnc()
}
```

### 引数にポインタ表現を取る counter 関数

- 引数 adctr のデータ型は「*int」 => **adctr は int 参照型** *adctr としてアドレスを参照したら int 型だから
  - ポインタの使用をデータ型として表す記法
  - 「\*adctr のデータ型は int」という意味
  - C 言語などポインタを用いる言語では共通に参照型と呼ばれている
- クロージャと違ってシンプル
- ポインタを使えばそのアドレスの数値を書き換えて作業が終了する

```
package main

import "fmt"

func counter(adctr *int) {
  *adctr++ // ctrのアドレスの値をインクリメント。戻り値は不要
}

func main() {
	ctr := 10 // ctrを宣言
	counter(&ctr) // ctrのアドレスを渡す
	fmt.Println(ctr)
}
```

### ここまでの応用

- サイコロを使ったプログラム
- 全体像

```
package main

import "fmt"

type roll struct {
	round int
	score int
}

func begin() *roll {
	fmt.Println("サイコロを投げます")
	return &roll{0, 0} // ① 構造体rollのインスタンスのアドレスを返す
}

func throw(r *roll, x int) {

	r.round++ // ③ 本来は*rと書かないといけない

	if x%2 == 0 {
		r.score++
	}

	fmt.Printf("%d回目: スコア=%d\n",
		r.round, r.score)

}

func main() {
	myroll := begin()
	throw(myroll, 6) // ② &が不要
	throw(myroll, 5)
	throw(myroll, 2)
	throw(myroll, 4)
	throw(myroll, 3)
}
```

- ① の解説
- ここでは、構造体 roll のインスタンスのアドレスを返している。
- 戻り値は「\*roll 型」とする
  - **\*をつければ roll 型になるという意味**

```
func begin() *roll {
	fmt.Println("サイコロを投げます")
	return &roll{0, 0} // ① 構造体rollのインスタンスのアドレスを返す
}
```

- ② の解説
- throw 関数は引数に構造体の roll のアドレスを受け取る関数になっている。
- ① で roll のアドレスが返ってくるのでここでは&が不要

```
throw(myroll, 6) // ② &が不要
```

- ③ の解説
- r は roll のアドレスなので、実際に roll インスタンスとして扱うには\*r とする必要がある。
- だが、**関数の中では「\*r」を省略して「r」として書いて良い**ので r とかける！！

```
func throw(r *roll, x int) {

	r.round++ // ③ 本来は*rと書かないといけない

	if x%2 == 0 {
		r.score++
	}

	fmt.Printf("%d回目: スコア=%d\n",
		r.round, r.score)

}
```

## 今日の学び

- 6 章でクロージャの謎がわかるという胸熱展開。
- 構造体のインスタンスにもポインタ表現を使って、アドレスから内容を読み書きできる。
- 同じ変数や構造体を使いまわしたいなら、そのアドレスを渡してアドレスの値に対して読み書きすれば間違いない
- 6 章走り切りたかったけど、集中力がもたなかったのでここまで。
