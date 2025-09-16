# プロジェクト概要

## プロジェクトの目的
個人技術ブログサイト「Small Changes」(https://snyt45.com/) を Hugo で運営している静的サイトプロジェクト。

## 技術スタック
- **静的サイトジェネレータ**: Hugo (Extended版が必要)
- **テーマ**: Stack v3 (hugo-theme-stack)
- **言語**: Go modules (go 1.23.7)
- **解析**: Google Analytics (G-FFNLJVXS4C)

## プロジェクト構造
```
hugo_blog/
├── config/_default/  # Hugo設定ファイル群
│   ├── hugo.toml    # メイン設定
│   ├── params.toml  # パラメータ設定
│   ├── menu.toml    # メニュー設定
│   └── ...
├── content/         # コンテンツ
│   ├── post/       # ブログ記事（年/日付_slug形式で整理）
│   ├── about/      # Aboutページ
│   ├── archives/   # アーカイブページ
│   └── search/     # 検索ページ
├── archetypes/     # 記事テンプレート
│   ├── default.md
│   └── custom-post.md
├── scripts/        # ユーティリティスクリプト
│   └── create_post.sh  # 記事生成スクリプト
├── assets/         # アセット
├── resources/      # リソース
├── go.mod         # Go modules定義
└── README.md      # プロジェクトドキュメント
```

## 記事の管理方式
- 記事は `content/post/年/YYYYMMDD_slug/index.md` 形式で保存
- 記事URLは `/post/年/slug/` 形式でアクセス
- 日付管理とSEO対応のためのslug形式を採用