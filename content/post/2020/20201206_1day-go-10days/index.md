---
title: "たった1日で基本が身に付く！ Go言語 超入門@10日目"
description:
slug: "1day-go-10days"
date: 2020-12-06T16:32:42+0000
lastmod: 2020-12-06T16:32:42+0000
image:
math:
draft: false
---

今日で最後までやりきりたいと思います。

超入門が終わったら Udemy の Go 講座を進めていこうと思います。

Udemy はメモ機能が充実していて、動画の〇秒の部分にメモみたいなことができるので

基本的には Udemy で完結してしまいそうです。

最終的に整理する際はこのブログでまとめたりするかもですが、Udemy 内で完結させたほうが学習効率も良さそうなので学習記録的なものはちょっとストップするかもですね。

あと、GoLand という IDE を入れてみましたが捗りますね！

無料体験 30 日後は個人利用だと月額 1,000 円かかりますが・・・

とりあえず体験版で使っていこうと思います。

## CHAPTER 8 　 Go 言語の魅力を体験するプログラム

### 複数のチャンネルを使い分ける

- 自分の中のチャンネルの流れをコメントに記載

```
package main

import (
	"fmt"
	"math/rand"
	"time"
)

func choose(cf, cd, quit chan int) {
	for {
		select {
		case count := <-cf: // ④cfチャンネルに値が入るまで待機。値が入ると式が評価されて文字が出力される
			fmt.Printf("カエルが%d匹\n", count)
		case count := <-cd:
			fmt.Printf("アヒルが%d匹\n", count)
		case <-quit:
			fmt.Printf("終了")
			return
		}
	}
}

func countRandom(cf, cd, quit chan int) {
	rand.Seed(time.Now().UnixNano())
	for i := 0; i < 5; i++ {
		count := rand.Intn(10) + 1
		if count%2 == 0 {
			cf <- count // ③countに値が入るまでcfチャンネルは待機している。
		} else {
			cd <- count
		}
	}
	quit <- 1
}

func main() {
	cf := make(chan int) // ①チャンネルを作成
	cd := make(chan int)
	quit := make(chan int)

	go countRandom(cf, cd, quit) // ②main関数とは別にゴルーチンを作成。この時点で並列に処理が走る。通常だと、main関数が終わるとゴルーチンも強制的に処理が終了するが、チャンネルを使っているため処理が継続する
	choose(cf, cd, quit) // quitチャンネルが評価されるとchooseでreturnが返り、main関数も処理が終了するのでプログラムが終了する
}

// 実行結果
カエルが6匹
カエルが6匹
アヒルが1匹
カエルが2匹
アヒルが7匹
終了
```

### Go 言語で書ける Web サーバー

- Web サーバープログラムに必要なパッケージ

- net/http
  - 要求を受け取ったり応答を返したりサーバーの随所で活躍する
- html
  - Web ページの表示に用いる
- html/template
  - 文字列から HTML 文を作成する

### Go 言語の Web サーバーを動かすしくみ

```
package main

import (
	"fmt"
	"html/template"
	"io/ioutil"
	"net/http"
	"os"
)

func main() {
	http.Handle("/", http.HandlerFunc(makePage))
	http.ListenAndServe(":8782", nil)
}

func makePage(resw http.ResponseWriter, req *http.Request) {
	content, err := ioutil.ReadFile("indexhtml.txt")
	if err != nil {
		fmt.Println("テンプレートファイル読み込み失敗", err)
		os.Exit(1)
	} else {
		templatestr := string(content)
		templ := template.Must(template.New("sendname").Parse(templatestr))
		templ.Execute(resw, req.FormValue("yourname"))
	}
}
```

- Go の実行環境には簡単な Web サーバーが備わっている。
- それを起動するのが以下のコード

```
http.ListenAndServe(":8782", nil)
```

- 最初の引数はポート番号
- 2 番目の引数にはサーバーの要求を処理する関数名を指定。nil にしておくと Go 言語に備わっている関数が呼ばれる。
  - 要求が来た時に呼ばれる関数は一般にハンドラと呼ばれる

### 特定のページが呼ばれた場合

- サーバーには色々な段階で呼ばれるハンドラがある

```
http.Handle("/", http.HandlerFunc(makePage))
```

- ドキュメントルートが呼ばれたときのハンドラを指定している
- /にアクセスしたときに、makePage 関数を呼び出す

```
func makePage(resw http.ResponseWriter, req *http.Request) {
```

- req を受け取って、必要なデータを取り出す
- resw で HTML 文を書き出す

### テンプレートをファイルから読み込む

- ドキュメントルートにアクセスしたらフォームを表示し、送信した値を元に Web ページを再描画する。
- HTML をテキストファイルとして読み込む

```
ontent, err := ioutil.ReadFile("indexhtml.txt")
```

- 読み込むテキストファイルは HTML 形式で書かれ Go 言語で解析する記述を埋め込んである

```
<html>
<head>
<title>Go言語で書くWebサーバー</title>
</head>
<body>
こんにちは！
{{if .}}
{{.}}さん
{{else}}
すみません、どちらさまですか
{{end}}

<form action="/" name=f method="GET">
<input size=40 name=yourname value="" title="名前を入力してください:">
<input type=submit value="送信" >
</form>
</body>
</html>
```

### フォームからの送信データを受け取る

- 文字列から HTML の内容を作成

```
templ, err := template.Parse(templateStr)
```

- 上記でもよいが、err でエラー処理を書くのが面倒のため、Must 関数を用いる。

- エラーが出たら処理を停止してくれる Must 関数

```
templ := template.Must(template.New("sendname").Parse(templatestr))
```

- 要求を受け取ってページを書き出す
  - フォームから送信されてきたデータで yourname を受け取って、resw で HTML 文に書き出している

```
templ.Execute(resw, req.FormValue("yourname"))
```

## 今日の学び

- 少しだけチャンネルのイメージが分かるようになってきた。Rails の Action Cable のイメージに近いかも。
- Go 言語のみで Web サーバーを立上げて HTML を描画して、フォームデータを送信してそのデータを元にページを再描画ということを行った。すごいシンプルなコードでできたので感動した。少ないコードでこういうことができると最小工数で試すことができるのでとてもよい。
