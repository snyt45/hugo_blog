# タスク完了時のチェックリスト

## 記事作成・編集時
1. **Frontmatterの確認**
   - title, date, slug が適切に設定されているか
   - draft: false（公開する場合）

2. **ファイル配置の確認**
   - 正しいディレクトリ構造（content/post/年/日付_slug/）
   - index.mdファイルが存在

3. **ローカル確認**
   ```bash
   # ドラフトも含めて確認
   hugo server -D
   ```
   - 記事が正しく表示されるか
   - リンクが正常に機能するか
   - 画像が表示されるか

4. **ビルド確認**
   ```bash
   # 本番ビルド
   hugo
   ```
   - エラーなくビルドが完了するか
   - publicディレクトリが生成されるか

## コード変更時
1. **動作確認**
   - hugo serverで変更が反映されるか
   - エラーログがないか確認

2. **Git操作**
   ```bash
   git status  # 変更ファイル確認
   git diff    # 変更内容確認
   ```

## テーマ更新時
1. **依存関係の更新**
   ```bash
   hugo mod get -u github.com/CaiJimmy/hugo-theme-stack/v3
   hugo mod tidy
   ```

2. **互換性確認**
   - サイトが正常に表示されるか
   - カスタマイズが保持されているか

## 注意事項
- このプロジェクトには専用のlint/format/testコマンドは設定されていない
- Hugoの組み込み検証機能に依存
- `hugo`コマンドのエラー出力を確認することが重要