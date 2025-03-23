---
title: "VSCODEで保存時にprettierで自動修正を行う方法"
description:
slug: "vscode-prettier"
date: 2021-05-30T00:58:12+0000
lastmod: 2021-05-30T00:58:12+0000
image:
math:
draft: false
---

VSCODE の拡張機能[Prettier - Code formatter](https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode)をインストールします。

今回はワークスペース毎に設定を反映させます。

VSCODE の左下の歯車 > 設定 > ワークスペースタブに移動します。

設定の検索窓から「format」で検索して「Format On Save」にチェックを入れます。

![VSCODE設定](workspace-settings.png)

すると、プロジェクトのルート以下に「.vscode/settings.json」というファイルが作成されます。
※直接自分で作成しても OK ですが、ファイルのスペルミスで設定が反映されなくて時間を消耗したのでこの方法で設定ファイルを作るのが間違いないです。

settings.json は次のようになっていると思います。

```
{
  "editor.formatOnSave": true,
}
```

残りの設定は直接 settings.json に定義していきます。

```
{
  "editor.formatOnSave": true,
  "[vue]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[javascript]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[typescript]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
}
```

今回は Rails + Vue.js + TypeScript を使ったプロジェクトなので、vue,javascript,typescript のフォーマッタに prettier を使う設定にしています。

`"editor.formatOnSave": true`にしているので、保存時に自動でフォーマットされ指定された拡張子の場合はフォーマッタに prettier が使われるようになります。
