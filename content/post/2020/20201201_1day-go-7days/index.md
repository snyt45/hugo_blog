---
title: "たった1日で基本が身に付く！ Go言語 超入門@7日目"
description:
slug: "1day-go-7days"
date: 2020-12-01T16:28:54+0000
lastmod: 2020-12-01T16:28:54+0000
image:
math:
draft: false
---

[たった 1 日で基本が身に付く！ Go 言語 超入門：書籍案内｜技術評論社](https://gihyo.jp/book/2020/978-4-297-11617-0)

途中、ざーっとやった所もあるけどやっと最終章にやってきました。

ここが一番やりたかったところなのでうれしい。

今日も頑張っていきます。

## CHAPTER 8 　 Go 言語の魅力を体験するプログラム

### キーボードからの入力

```
package main

import "fmt"

func main() {
	var input string
	for {
		fmt.Print("何か入力してください。'q'で終了： ")
		fmt.Scanln(&input)

		if input == "q" {
			break
		}
		fmt.Println(input, "が入力されました")
	}
	fmt.Println("お疲れ様でした！")
}
```

- キー入力の値を受け取るのは、fmt パッケージの Scanln という関数
  - 「Scan」は、OS で定められた標準入力を受け取ることを示す名前
    - ほとんどの OS では、標準入力はキー入力
  - 「ln」は、改行キー(エンターキー)が押されるまで読み込むという意味
  - 引数には&input を指定して、同じ場所に保存する

### ファイルからの入力

- データ量が多くなれば、キー入力もファイル読み込みのほうが便利
- ファイルの読み込みには、ioutil パッケージにある ReadFile 関数を用いる
- ioutil というパッケージは io パッケージの下部にあるので io/ioutil と書く

```
import "io/ioutil"

content, err := ioutil.ReadFile("data.txt")
```

- 上記例では、このプログラムと同じフォルダ内にある data.txt の内容を読み込むように記述

```
package main

import (
	"fmt"
	"io/ioutil"
	"strings"
	"os"
)

func main() {
	content, err := ioutil.ReadFile("data.txt")
	if err != nil {
		fmt.Println("ファイルの読み込みエラー", err)
		os.Exit(1)
	} else {
		cstr := string(content)
		lows := strings.Split(cstr, "\n")
		for i, v := range lows {
      if i > 0 && len(v) > 1 {
				data := strings.Split(v, ",")
				fmt.Printf("%sは%s円\n", data[0], data[1])
			}
		}
	}
}
```

### 範囲節 range による for

- 確か 7 章で出てきたけど、ちゃんと理解してなかったので。

```
for i, v := range lows { // iにはインデックス、vにはインデックスの位置の場所の要素が入る
  if i > 0 && len(v) > 1 { // 二行目以降から処理をする
    data := strings.Split(v, ",") // カンマで分割
    fmt.Printf("%sは%s円\n", data[0], data[1]) // 1つ目の要素と2つ目の要素をそれぞれ表示
  }
}
```

[【Go】基本文法 ⑤\(連想配列・ Range\) \- Qiita](https://qiita.com/k-penguin-sato/items/a320072fa09502bde3e9)

- range は Slice や Maps を一つずつ反復処理するために使う
- スライスを range で繰り返す場合は、反復ごとに 2 つの変数を返す
  - 1 つめの変数：インデックス(index)
  - 2 つめの変数：インデックスの場所の要素(value)

### ファイルへの出力

- ファイルへの書き込みには ioutil.WriteFile 関数を用いる

```
err := ioutil.WriteFile("datafile.txt", wdata, 0777)
```

- 第 1 引数：書き込み先ファイル名
- 第 2 引数：書き込むデータ
- 第 3 引数：アクセス権
  - 0644 であれば読み取り専用
  - 0777 であれがすべて実行可能

```
package main

import (
	"fmt"
	"io/ioutil"
	"os"
)

func main() {
	var input string
	var content string
	for {
		fmt.Print("何か入力してください。's'で保存：")
		fmt.Scanln(&input) // キー入力したものを&inputに保存

		if input == "s" { // sが入力されたら、処理を抜ける
			break
		}
		content += input // sが入力されるまでは、contentに入力した文字を保存し続ける
	}

	wdata := []byte(content) // 文字をバイトに変換
	err := ioutil.WriteFile("datafile.txt", wdata, 0777) // wdataの内容がdatafile.txtに反映されてファイルが作られる
	if err != nil {
		fmt.Println("書き込みエラーです", err)
		os.Exit(1)
	} else {
		fmt.Println(content)
		fmt.Println("以上、ファイルに保存しました")
	}
}
```

## 今日の学び

- キー入力やファイルの入力や出力をプログラムで扱えると一気に表現できることが増えた気がする
- range を使った for 文について復習できたので良かった
