# 推奨コマンド一覧

## 開発サーバー起動
```bash
# ローカル開発サーバー起動（ドラフト記事も表示）
hugo server -D

# ネットワーク上の他デバイスからもアクセス可能にする場合
hugo server --bind 0.0.0.0 -D
```

## 記事の作成
```bash
# 新規記事作成（自動的に年/日付_slug形式で整理される）
# 使用例: scripts/create_post.sh my-new-post
# 日付指定例: scripts/create_post.sh my-new-post 20250401
scripts/create_post.sh <スラッグ> [日付(YYYYMMDD)]
```

## ビルド
```bash
# 本番用ビルド（publicディレクトリに生成）
hugo

# ドラフトも含めてビルド
hugo -D
```

## テーマ更新
```bash
# Stackテーマを最新版に更新
hugo mod get -u github.com/CaiJimmy/hugo-theme-stack/v3
hugo mod tidy
```

## ショートコード使用例
```markdown
# X(Twitter)埋め込み
{{< x user="<user>" id="<id>" >}}

# YouTube埋め込み
{{< youtube MrZolfGm8Zk >}}
```

## Darwinシステムコマンド
```bash
# macOS固有のファイル検索
find . -name "*.md"

# macOS用のgrep (BSD版)
grep -r "検索文字列" .

# ファイルのタイムスタンプ確認
stat -f "%Sm" -t "%Y%m%d" file.md

# ディレクトリツリー表示（treeコマンドがない場合）
ls -R
```

## Git操作
```bash
# 状態確認
git status

# コミット
git add .
git commit -m "メッセージ"

# プッシュ
git push origin main
```