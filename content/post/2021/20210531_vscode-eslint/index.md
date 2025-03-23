---
title: "VSCODE上でESLintの問題が検知されない場合にESLintを有効にする方法"
description:
slug: "vscode-eslint"
date: 2021-05-31T00:59:42+0000
lastmod: 2021-05-31T00:59:42+0000
image:
math:
draft: false
---

プロジェクトのディレクトリ構成

```
.
├── README.md
├── api // Rails Api
├── doc
├── docker-compose.yml
├── front // Vue.js
|   └── package.json
└── vetur.config.js
```

api,front でディレクトリを分けており package.json がサブディレクトリにある構成だった。

VSCODE の設定に下記を追加したところ、VSCODE 上で ESLint の問題が検知されるようになりました。

```
{
  "eslint.workingDirectories": [{ "mode": "auto" }],
}
```

こちらの[記事](https://scrapbox.io/zatsu-memo/monorepo%E3%81%AA%E3%83%97%E3%83%AD%E3%82%B8%E3%82%A7%E3%82%AF%E3%83%88%E3%81%A7VSCode+ESLint%E3%81%8C%E3%81%86%E3%81%BE%E3%81%8F%E5%8B%95%E3%81%8B%E3%81%AA%E3%81%84%E3%81%A8%E3%81%8D)を参考に解決しました。
