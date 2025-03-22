---
title: "たった1日で基本が身に付く！ Go言語 超入門@9日目"
description:
slug: "1day-go-9days"
date: 2020-12-03T16:31:35+0000
lastmod: 2020-12-03T16:31:35+0000
image:
math:
draft: false
---

今日はついにゴルーチンです

ゴルーチンってなんだ？ってところからですが、今日もやっていきます。

## CHAPTER 8 　 Go 言語の魅力を体験するプログラム

### 並列処理

- 考え方は 2 つ
  - 高速で大量の計算が必要なとき
  - 時間がかかる操作をしている間に、他の操作を進めたいとき

### goroutine(ゴルーチン)

- ゴルーチンは、関数の実行時に`go`をつけることで、1 つのスレッドとなる記法

```
package main

import (
	"fmt"
	"time"
)

func count(name string, tlen int) {
	for i := 0; i < 5; i++ {
		time.Sleep(time.Duration(tlen) * time.Millisecond)
		fmt.Printf("%sが%d匹\n", name, i+1)
	}
}

func main() {
	go count("カエル", 200) // 200ミリ秒ごとにカエルを数える
	go count("アヒル", 100) // 100ミリ秒ごとにアヒルを数える
}
```

- `time.Duration(tlen) * time.Millisecond`

```
// 同じ型なので計算できる
time.Duration(tlen) * time.Millisecond
100000000
// int型とtime.Duration型なので計算できない
tlen * time.Millisecond
Unable to eval expression: "mismatched types "int" and "time.Duration""
// ただ、後で出てくるが次のは計算できるみたい。。なぜ？
3000 * time.Millisecond
3000000000
```

- 200 ミリ秒ごとにカエル、100 ミリ秒ごとにアヒルを数えるスレッドを並行させるプログラム
- しかし、`ビルド・実行しても何も出力されない`
- ゴルーチンを呼び出しているのは main 関数。ゴルーチンと main 関数と並行で実行できるが、main 関数は 2 つのゴルーチンを呼び出したあとすぐに終了してしまうので、結局ゴルーチンも終了してしまう。

- 次のように main 関数に 3000 ミリ秒スリープしてもらうとゴルーチンも実行できる

```
func main() {
	go count("カエル", 200)
	go count("アヒル", 100)
  time.Sleep(3000 * time.Millisecond) // この行を追加
}

// 実行結果
アヒルが1匹
アヒルが2匹
カエルが1匹
アヒルが3匹
カエルが2匹
アヒルが4匹
アヒルが5匹
カエルが3匹
カエルが4匹
カエルが5匹
```

### チャンネル

- さっきの例は main 関数を寝かせておく変なプログラム
- そこで用意されているのが`チャンネル`というデータ型
- データ型の名前は`chan`

- チャンネルの基本的な使い方

```
c := make(chan int)
c <-1    // チャンネルに数値1を送る
r := <-c // チャンネルから値を受け取る(1が代入される)
```

- 望みの目が出るまでサイコロを振ることを意図したプログラム
  - 構造体 dice
    - val フィールドを持つ
  - rollDice 関数
    - val に設定した値が出るまでサイコロを振り続ける

```
package main

import (
	"fmt"
	"math/rand"
	"time"
)

type dice struct {
	val int
}

func rollDice(d dice) {
	rand.Seed(time.Now().UnixNano()) // Seed生成。一度だけ設定すれば良いため戻り値を受け取る必要はない
	for {
		time.Sleep(10 * time.Millisecond) // 10ミリ秒スリープ
		if d.val == rand.Intn(10) { // 0～9までのランダムな整数を返す
			break // valと同じだった場合に無限ループを抜ける
		}
	}
	fmt.Printf("%dが出ました", d.val)
}

func main() {
	d1 := dice{2}
	d2 := dice{6}

	go rollDice(d1)
	go rollDice(d2)
}
```

- このプログラムだと先ほど同じく main 関数が終わると同時にゴルーチンも終了する
- そこでチャンネルを使用するようにプログラムに変更を加える

```
package main

import (
	"fmt"
	"math/rand"
	"time"
)

type dice struct {
	val int
}

func rollDice(d dice, c chan int) {
	rand.Seed(time.Now().UnixNano())
	for {
		time.Sleep(100 * time.Millisecond)
		v := rand.Intn(10)
		if d.val == v {
			fmt.Printf("出たー\n")
			break
		} else {
			fmt.Printf("%dか...%dではないな\n", v, d.val)
		}
	}
	c <- d.val // 望みの目が出たら、チャンネルに渡す
}

func main() {
	d1 := dice{2}
	d2 := dice{6}

	c := make(chan int) // チャンネルを作成
	go rollDice(d1, c)  // 並行して動作
	go rollDice(d2, c)  // 並行して動作

	x, y := <-c, <-c // チャンネルの値を2回送る

	fmt.Printf("%dが出ました\n", x)
	fmt.Printf("%dが出ました\n", y)
}

// 実行結果
6か...2ではないな
4か...6ではないな
9か...2ではないな
4か...6ではないな
4か...6ではないな
7か...2ではないな
8か...2ではないな
2か...6ではないな
1か...6ではないな
6か...2ではないな
出たー           // go rollDice(d1, c)のほうが先に望みの目が出た。でもまだロックされている。
5か...6ではないな
0か...6ではないな
2か...6ではないな
0か...6ではないな
8か...6ではないな
0か...6ではないな
2か...6ではないな
4か...6ではないな
5か...6ではないな
9か...6ではないな
9か...6ではないな
8か...6ではないな
出たー           // go rollDice(d2, c)も望みの目が出た。これで、次の処理に進む
2が出ました
6が出ました
```

- チャンネルは自らの流れを管理してくれる。
- 送られた値の受けてがいないまま新たな値を送られても、そこでロックして待たせます
- データが送られていないのに受け取りを要求されてもロックします

### ちょっと脱線して Go のデバッグ環境を構築

- `go get -u github.com/derekparker/delve/cmd/dlv`で delve をインストール
- `dlv version`でバージョン確認
- vscode-go はすでにインストール済み
- Launch Debug で launch.json を作る。デフォルトで OK
- ブレークポイントを打って、F5 で実行。以上
- 変数の中身を見れたり、ステップで実行できたりができる。
- ただ残念なことに関数呼び出しがまだできないみたい
  - [debug: support function calls via delve 'call' · Issue \#100 · golang/vscode\-go](https://github.com/golang/vscode-go/issues/100)
- vscode-go ではなく直接 delve を使ったほうがまだやれることは多かった。
  - delve でも call で関数呼び出しは出来なかった・・・
  - whatis [変数名]で型が調べられるのは地味に楽
  - [Golang のデバッガ delve の使い方 \- Qiita](https://qiita.com/minamijoyo/items/4da68467c1c5d94c8cd7)
- rails console みたいに色々できないのだろうか…今のところかなり不便と感じる

## 今日の学び

- Go の勉強をする中で、ライブラリを使いだすとすぐに自分の書いたコードがブラックボックスになる感覚に気が付いた。進めば進むほど、ライブラリは便利だがその反面楽をしすぎて考えることが減り、自分の成長機会を減らしていることに気づいた。楽をしない方法でできるだけ理解したコードを増やしてことを意識したい。
- ゴルーチンのチャンネルについてざっくり分かった。少しずつ理解度をあげたい。

## おまけ

- [プログラミングを上達させる、ロジックから考える勉強方法【脱初心者】](https://yamatonamiki.com/blog/991/)
  - ロジックから考える訓練が足りないのはマジだと思う…どうすればいいか
