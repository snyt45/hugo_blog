# hugo_blog
## 前提

- go コマンド
- Hugo のextended バージョン

## 使用法

```bash
# サーバー起動（ローカルネットワーク上の別端末からアクセス可能にする）
hugo server --bind 0.0.0.0

# 下書きも含めてビルド
hugo server --bind 0.0.0.0 -D

# 記事生成
hugo new content post/{slug}/index.md

# テーマ更新
hugo mod get -u

# 不要な依存関係の削除
hugo mod tidy
```

## 参考
- Stackテーマを使用
  - https://zenn.dev/seita1996/articles/hugo-markdown-blog
