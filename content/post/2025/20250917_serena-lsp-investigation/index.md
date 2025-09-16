---
title: "SerenaとLSPの仕組みを調べてコードインデックス機能を理解してみた"
description: "AI開発支援ツールSerenaの内部構造とLSPを活用したシンボルインデックス機能について実際に試しながら調査した記録"
slug: "serena-lsp-investigation"
date: 2025-09-17T00:54:00+0900
lastmod: 2025-09-17T00:54:00+0900
image:
math:
draft: false
---

> この投稿は私の作業メモをもとに AI によって生成されました。内容の正確性については保証できませんので、参考程度にご覧ください。

## 前置き

最近 AI 開発支援ツールとして注目されている Serena について調べる機会がありました。特に、[Serena で実装時トークン使用を最大推定 90%削減](https://zenn.dev/rio_dev/articles/6b67e58bcf19a2)という記事を読んで、「変数の位置を記憶したシンボルテーブルを作っていて、それをインデックスとして活用している」という部分が気になったのがきっかけです。

実際にどういう仕組みでコード解析を行い、どのようにしてトークン効率を向上させているのかを理解したいと思い、Serena のソースコードを読みながら実際に動かしてみました。

## Serena の基本構造

まず、Serena がどのようなツールなのかを GitHub リポジトリから確認してみました。

https://github.com/oraios/serena

pyproject.toml を見ると、3 つの主要なコマンドが定義されています：

```python
[project.scripts]
serena = "serena.cli:top_level"
serena-mcp-server = "serena.cli:start_mcp_server"
index-project = "serena.cli:index_project"        # deprecated
```

- `serena`: メインコマンド
- `serena-mcp-server`: MCP サーバーの開始
- `index-project`: プロジェクトのインデックス作成（非推奨）

## MCP サーバーと FastMCP の関係

`serena-mcp-server`コマンドの実装を追ってみると、興味深い構造が見えてきました。

```python
def start_mcp_server(self):
    # ...
    mcp = FastMCP(lifespan=self.server_lifespan, host=host, port=port, instructions=instructions)
    return mcp
```

Serena は FastMCP というライブラリを使って MCP（Model Context Protocol）サーバーを作成しているということがわかりました。

FastMCP について調べてみると：
https://github.com/jlowin/fastmcp

これは外部ライブラリで、MCP サーバーを簡単に作成するためのフレームワークのようです。

FastMCP に渡している引数は`lifespan`、`host`、`port`、`instructions`だけですが、実際のツール定義は`server_lifespan`の中で`_set_mcp_tools`メソッドが呼ばれて設定されているということがコードを読んで理解できました。

## プロジェクトインデックス機能の実装

Serena の肝となるシンボルインデックス機能について調べてみました。

現在は`index-project`コマンドは非推奨になっており、代わりに`serena project index`コマンドを使うようになっています。

実際に試してみました：

```bash
uvx --from git+https://github.com/oraios/serena serena project index
```

ですが、最初は実行するとタイムアウトエラーが発生してしまいました：

```
TimeoutError: Request timed out (timeout=10.0)
```

どうやら LSP サーバーとの通信でタイムアウトが発生しているようでした。タイムアウト時間を延ばして再実行してみました：

```bash
uvx --from git+https://github.com/oraios/serena serena project index --log-level INFO --timeout 60
```

今度は成功し、以下のような出力が得られました：

```
Symbols saved to /Users/snyt45/work/toypo-api/.serena/cache/ruby/document_symbols_cache_v23-06-25.pkl
Failed to index 3 files, see:
/Users/snyt45/work/toypo-api/.serena/logs/indexing.txt
```

## LSP サーバーとの連携

エラーログやコード解析から、Serena が LSP（Language Server Protocol）を活用してシンボル情報を取得していることがわかりました。

具体的には：

1. プロジェクト内のコードファイルを解析
2. LSP サーバーを起動してシンボル情報を取得
3. シンボルテーブルを pickle 形式でキャッシュ保存
4. 必要時にキャッシュからシンボル情報を読み込み

これにより、AI モデルに渡すコンテキストを必要最小限に絞り込むことができ、トークン使用量を大幅に削減できるという仕組みになっています。

## 実際に生成されたキャッシュファイル

`.serena/cache/ruby/document_symbols_cache_v23-06-25.pkl`というファイルが生成されました。この pickle ファイルには、プロジェクト内の Ruby コードから抽出されたシンボル情報（クラス名、メソッド名、変数名、その位置情報など）が効率的に保存されているはずです。

これにより、AI モデルが「特定のメソッドの実装を知りたい」といった要求に対して、全ファイルを読み込む必要がなく、必要なシンボルの位置だけを特定して該当部分のコードだけを提供できるというわけです。

## 学んだこと

今回の Serena 調査で理解できたことをまとめると：

1. **LSP の活用**: 既存の LSP サーバーを活用することで、言語固有のコード解析を効率的に行える
2. **シンボルテーブルの威力**: コード全体を毎回解析する代わりに、事前にインデックス化することでパフォーマンスを向上
3. **MCP アーキテクチャ**: FastMCP を使ったモジュラーな設計により、拡張性の高いツールを構築
4. **キャッシュ戦略**: pickle 形式でのシンボル情報保存により、高速なアクセスを実現

## 今後の可能性

この仕組みを理解すると、さまざまな応用可能性が見えてきました：

- **社内ドキュメント検索**: Notion や Confluence の運用マニュアルとソースコードを組み合わせた質問応答システム
- **サポート精度向上**: 日直対応でのソースコード根拠付き回答システム
- **カスタム MCP サーバー**: 特定のプロジェクトに特化した AI 支援ツール

FastMCP の理解を深めることで、Serena のようなツールを自分でも作れそうだという手応えを感じました。

## まとめ

Serena のコードを実際に読んで動かしてみることで、LSP とシンボルインデックスを活用した AI 開発支援ツールの仕組みを理解することができました。特に、LSP サーバーとの連携部分やキャッシュ戦略については、今後自分でツールを作る際の参考になりそうです。

AI モデルを最大限活用するためには、いかに効率的にコンテキストを提供するかが重要で、Serena はその一つの優れた解決策を提示していると感じました。

引き続き Serena や FastMCP について深掘りして、実際に自分でも MCP サーバーを作ってみたいと思います。
