---
title: "VSCODE上でVeturの警告が出ていたので解決した"
description:
slug: "vscode-vetur"
date: 2021-05-31T01:00:40+0000
lastmod: 2021-05-31T01:00:40+0000
image:
math:
draft: false
---

この[記事](/posts/20210531/vscode-eslint/)と同じプロジェクトのディレクトリ構成の時に次の Vetur の警告が出っぱなしだったので解決したという話。

## エラー

```
Vetur can't find \`package.json\` in /workspaces/my-portal.
```

```
Vetur can't find \`tsconfig.json\` or \`jsconfig.json\` in /workspaces/my-portal.
```

package.json と tsconfig.json が見つけられないといわれている。

[FAQ \| Vetur](https://vuejs.github.io/vetur/guide/FAQ.html#vetur-can-t-find-tsconfig-json-jsconfig-json-in-xxxx-xxxxxx)

## エラー解決のためにやったこと

`vetur.config.js`をルートに配置したら警告が解消した。

```
// vetur.config.js
/** @type {import('vls').VeturConfig} */
module.exports = {
  // **optional** default: `{}`
  // override vscode settings
  // Notice: It only affects the settings used by Vetur.
  settings: {
    "vetur.useWorkspaceDependencies": true,
    "vetur.experimental.templateInterpolationService": true,
  },
  // **optional** default: `[{ root: './' }]`
  // support monorepos
  projects: [
    "./front", // shorthand for only root.
    {
      // **required**
      // Where is your project?
      // It is relative to `vetur.config.js`.
      root: "./front",
      // **optional** default: `'package.json'`
      // Where is `package.json` in the project?
      // We use it to determine the version of vue.
      // It is relative to root property.
      package: "./package.json",
      // **optional**
      // Where is TypeScript config file in the project?
      // It is relative to root property.
      tsconfig: "./tsconfig.ts",
      // **optional** default: `'./.vscode/vetur/snippets'`
      // Where is vetur custom snippets folders?
      snippetFolder: "./.vscode/vetur/snippets",
      // **optional** default: `[]`
      // Register globally Vue component glob.
      // If you set it, you can get completion by that components.
      // It is relative to root property.
      // Notice: It won't actually do it. You need to use `require.context` or `Vue.component`
      globalComponents: ["./src/components/**/*.vue"],
    },
  ],
};
```
