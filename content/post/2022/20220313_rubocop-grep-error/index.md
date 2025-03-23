---
title: "RuboCopのエラー名だけをgrepで抽出する"
description:
slug: "rubocop-grep-error"
date: 2022-03-13T15:06:10+0000
lastmod: 2022-03-13T15:06:10+0000
image:
math:
draft: false
---

仕事で開発環境構築をしていて RuboCop を導入しています。

実際に導入して`rubocop`を実行するとほとんどコードは書いていない状態にも関わらず結構なエラーが出ました。自動 fix しても 60 個くらいエラーが残りました。

このことから今後もデフォルトの設定だと次のようなことが考えられます。 - 厳しめの設定のため、結構エラーが出ること - それを調整するために時間がかかること

ですが、今のフェーズを考えるとできるだけそこに時間を割くというよりは価値提供するために時間を割きたいということもありました。

少し調べてみると、[RuboCop Airbnb](https://github.com/airbnb/ruby/tree/master/rubocop-airbnb)という Airbnb がメンテしている gem が存在していることを知りました。
Airbnb が使用している[Ruby Style Guide](https://github.com/airbnb/ruby)を見てみると、良い感じのルールで統一されていました。また、Airbnb 内で使われているものなので、おそらく色んなことが考慮されたうえでプロジェクト向きな設定が採用されていることが予想されます。

これらのことから、あまり RuboCop の設定周りに時間を割かずに良い感じの設定を手に入れたいという要望にマッチしそうだったので採用してみたいと思いました。

## RuboCop のエラー名だけを grep で抽出する

RuboCop → RuboCop Airbnb にするにあたって、RuboCop のエラー名だけを抽出して比較したかったので今回は grep を使って抽出してみました。

### RuboCop のエラー名を grep で抽出する

`grep -o "[C|W]:.*:" rubocop.txt` - rubocop.txt - `rubocop`時に出力されたエラーを保存したテキストファイルです。 - `-o` - 検索結果に一致した文字を表示する - `"[C|W]:.*:"` - C: または W: で始まり、:で終わる文字列に一致するものを検索するパターン

上記の`grep -o "[C|W]:.*:" rubocop.txt`で取得した文字列を sort したうえで uniq して重複を排除した結果を手に入れます。

```shell
❯ grep -o "[C|W]:.*:" rubocop.txt | sort | uniq
C: Layout/SpaceInsideArrayLiteralBrackets:
C: Metrics/MethodLength:
C: Naming/MethodParameterName:
C: Style/Documentation:
C: Style/Documentation: Missing top-level documentation comment for class Api::
C: Style/Documentation: Missing top-level documentation comment for class Types::
C: [Correctable] Bundler/OrderedGems:
C: [Correctable] Layout/ArgumentAlignment:
C: [Correctable] Layout/EmptyLineAfterGuardClause:
C: [Correctable] Layout/EmptyLines:
C: [Correctable] Layout/EmptyLinesAroundBlockBody:
C: [Correctable] Layout/ExtraSpacing:
C: [Correctable] Layout/FirstHashElementIndentation:
C: [Correctable] Layout/HashAlignment:
C: [Correctable] Layout/SpaceAroundOperators:
C: [Correctable] Layout/SpaceInsideArrayLiteralBrackets:
C: [Correctable] Layout/TrailingWhitespace:
C: [Correctable] Style/BlockComments:
C: [Correctable] Style/ExpandPathArguments:
C: [Correctable] Style/FrozenStringLiteralComment:
C: [Correctable] Style/GlobalStdStream:
C: [Correctable] Style/IfUnlessModifier:
C: [Correctable] Style/NumericLiterals:
C: [Correctable] Style/RedundantFetchBlock:
C: [Correctable] Style/StringLiterals:
C: [Correctable] Style/SymbolArray:
W: [Correctable] Lint/UnusedMethodArgument:
W: [Correctable] Lint/UselessMethodDefinition:
```

### RuboCop Airbnb のエラー名を grep で抽出する

基本的には RuboCop のとき同じです。

```shell
❯ grep -o "[C|W]:.*:" rubocop_airbnb.txt | sort | uniq
C: Layout/EmptyLines:
C: Layout/EmptyLinesAroundBlockBody:
C: Layout/ExtraSpacing:
C: Layout/HashAlignment:
C: Layout/LineLength:
C: Layout/SpaceAroundOperators:
C: Layout/SpaceInsideArrayLiteralBrackets:
C: Layout/TrailingWhitespace:
C: Style/BlockComments:
C: Style/TrailingCommaInArrayLiteral:
C: Style/TrailingCommaInHashLiteral:
```

## まとめ

ちょっとしたことですが、grep を使うことで欲しい結果を得ることができました。テキスト周りの加工や検索する術を知っていると仕事も効率的に進めていけると思うので少しずつ自分のものにしていきたいです。
