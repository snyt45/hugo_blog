# hugo_blog

## 前提

- go コマンド
- Hugo の extended バージョン

## サーバー起動

```bash
# サーバー起動（ローカルネットワーク上の別端末からアクセス可能にする）
# 下書きも含めてビルド
hugo server --bind 0.0.0.0 -D
```

## 記事生成

```bash
# 例: content/post/2025/20250322_test-post/index.md が作成される
scripts/create_post.sh test-post
```

## Stack テーマ更新

```bash
hugo mod get -u github.com/CaiJimmy/hugo-theme-stack/v3
hugo mod tidy
```

## 参考

- Stack テーマを使用
  - https://zenn.dev/seita1996/articles/hugo-markdown-blog
