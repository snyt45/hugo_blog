# コードスタイルと規約

## 記事作成の規約

### ファイル名規約
- 記事ファイル: `content/post/年/YYYYMMDD_slug/index.md`
- slug: 英数字とハイフン使用（小文字推奨）
- 例: `content/post/2025/20250322_test-post/index.md`

### Frontmatter構造
```yaml
---
title: "記事タイトル"
description: 記事の説明
slug: "url-slug"
date: 2025-03-22T10:00:00+09:00
lastmod: 2025-03-22T10:00:00+09:00
image: サムネイル画像パス（オプション）
math: 数式使用フラグ（オプション）
draft: false  # 公開時はfalse
---
```

### Markdown記法
- 標準的なMarkdown記法を使用
- Hugo独自のショートコードをサポート
- 日本語コンテンツ対応（hasCJKLanguage: true）

## シェルスクリプトの規約

### create_post.sh
- Bashスクリプト（#!/bin/bash）
- エラーハンドリングと使用方法表示
- 日付検証機能付き
- 環境変数を使用したHugoコマンド実行

## ディレクトリ構造の規約
- 記事: 年別に整理（content/post/YYYY/）
- 設定: config/_default/に集約
- スクリプト: scripts/ディレクトリ
- アーキタイプ: archetypes/（記事テンプレート）

## URL構造
- パーマリンク: `/post/:year/:slug/`
- 年とslugベースのURL構造
- SEOフレンドリーなURL設計