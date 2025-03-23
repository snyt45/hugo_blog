---
title: "DEPRECATION WARNING: Using / for division is deprecated and will be removed in Dart Sass 2.0.0."
description:
slug: "sass-error"
date: 2021-05-30T00:57:12+0000
lastmod: 2021-05-30T00:57:12+0000
image:
math:
draft: false
---

Rails + Vue.js + TypeScript の個人プロジェクトに Vuetify を導入しました。

開発環境は Docker を使っています。

Vuetify を導入した直後に docker-compose up でサーバーを起動すると、コンソールに記事タイトルの警告が出るようになりました。

## エラーログ

```
front_1  |
front_1  | Recommendation: math.div($border-radius-root, 2)
front_1  |
front_1  | More info and automated migrator: https://sass-lang.com/d/slash-div
front_1  |
front_1  |    ╷
front_1  | 14 │     'sm': $border-radius-root / 2,
front_1  |    │           ^^^^^^^^^^^^^^^^^^^^^^^
front_1  |    ╵
front_1  |     node_modules/vuetify/src/styles/settings/_variables.scss 14:11  @import
front_1  |     node_modules/vuetify/src/styles/settings/_index.sass 1:9        @import
front_1  |     node_modules/vuetify/src/styles/styles.sass 2:9                 @import
front_1  |     node_modules/vuetify/src/components/VApp/VApp.sass 1:9          root stylesheet
front_1  |
front_1  | DEPRECATION WARNING: Using / for division is deprecated and will be removed in Dart Sass 2.0.0.
front_1  |
front_1  | Recommendation: math.div($grid-gutter, 2)
front_1  |
front_1  | More info and automated migrator: https://sass-lang.com/d/slash-div
front_1  |
front_1  |    ╷
front_1  | 56 │ $container-padding-x: $grid-gutter / 2 !default;
front_1  |    │                       ^^^^^^^^^^^^^^^^
front_1  |    ╵
front_1  |     node_modules/vuetify/src/styles/settings/_variables.scss 56:23  @import
front_1  |     node_modules/vuetify/src/styles/settings/_index.sass 1:9        @import
front_1  |     node_modules/vuetify/src/styles/styles.sass 2:9                 @import
front_1  |     node_modules/vuetify/src/components/VApp/VApp.sass 1:9          root stylesheet
front_1  |
front_1  | DEPRECATION WARNING: Using / for division is deprecated and will be removed in Dart Sass 2.0.0.
front_1  |
front_1  | Recommendation: math.div($grid-gutter, 12)
front_1  |
front_1  | More info and automated migrator: https://sass-lang.com/d/slash-div
front_1  |
front_1  |    ╷
front_1  | 61 │     'xs': $grid-gutter / 12,
front_1  |    │           ^^^^^^^^^^^^^^^^^
front_1  |    ╵
front_1  |     node_modules/vuetify/src/styles/settings/_variables.scss 61:11  @import
front_1  |     node_modules/vuetify/src/styles/settings/_index.sass 1:9        @import
front_1  |     node_modules/vuetify/src/styles/styles.sass 2:9                 @import
front_1  |     node_modules/vuetify/src/components/VApp/VApp.sass 1:9          root stylesheet
front_1  |
front_1  | DEPRECATION WARNING: Using / for division is deprecated and will be removed in Dart Sass 2.0.0.
front_1  |
front_1  | Recommendation: math.div($grid-gutter, 6)
front_1  |
front_1  | More info and automated migrator: https://sass-lang.com/d/slash-div
front_1  |
front_1  |    ╷
front_1  | 62 │     'sm': $grid-gutter / 6,
front_1  |    │           ^^^^^^^^^^^^^^^^
front_1  |    ╵
front_1  |     node_modules/vuetify/src/styles/settings/_variables.scss 62:11  @import
front_1  |     node_modules/vuetify/src/styles/settings/_index.sass 1:9        @import
front_1  |     node_modules/vuetify/src/styles/styles.sass 2:9                 @import
front_1  |     node_modules/vuetify/src/components/VApp/VApp.sass 1:9          root stylesheet
front_1  |
front_1  | DEPRECATION WARNING: Using / for division is deprecated and will be removed in Dart Sass 2.0.0.
front_1  |
front_1  | Recommendation: math.div($grid-gutter, 3)
front_1  |
front_1  | More info and automated migrator: https://sass-lang.com/d/slash-div
front_1  |
front_1  |    ╷
front_1  | 63 │     'md': $grid-gutter / 3,
front_1  |    │           ^^^^^^^^^^^^^^^^
front_1  |    ╵
front_1  |     node_modules/vuetify/src/styles/settings/_variables.scss 63:11  @import
front_1  |     node_modules/vuetify/src/styles/settings/_index.sass 1:9        @import
front_1  |     node_modules/vuetify/src/styles/styles.sass 2:9                 @import
front_1  |     node_modules/vuetify/src/components/VApp/VApp.sass 1:9          root stylesheet
front_1  |
front_1  | WARNING: 1 repetitive deprecation warnings omitted.
front_1  |
```

## エラーログの意味

Deepl 翻訳：

`DEPRECATION WARNING: 分割に / を使用することは非推奨であり、Dart Sass 2.0.0 で削除されます。`

エラーログに出ていた[リンク](https://sass-lang.com/documentation/breaking-changes/slash-div)に飛ぶと sass のサイトに遷移しました。

こちらは sass が出している警告のようです。

破壊的変更があり 1.33.0 以降、`/`は除算演算として使えず単なるリストセパレータに変更されるようだ。

そのため、Vuetify で`/`を除算演算として使っている箇所で警告が出ているようだ。

また、今後`/`は`math.div()`に置き換わるとのこと。

## エラーログ解消のためにやったこと

[リリース](https://github.com/sass/dart-sass/releases)をみると`1.33.0`から`/`を除算演算としての使用が非推奨になっているみたいだ。

`package.lock.json`のバージョンは`1.34.0`なのでバージョンを下げればよさそうだ。

`package.json`のバージョンを下記のように書き換える。

```
"sass": "^1.32.0",
↓
"sass": "~1.32.12",
```

`package.lock.json`を削除する。
Dockerfile に変更はないため、`docker-compose up`しても npm install は走らないため個別に実行する。

`docker-compose up`
`docker-compose run --rm front npm install`

これで sass のエラーは出なくなった。
