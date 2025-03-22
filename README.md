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
```
