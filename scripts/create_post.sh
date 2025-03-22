#!/bin/bash

# スクリプトの使用方法を表示する関数
function show_usage {
  echo "使用方法: $0 <スラッグ>"
  echo "例: $0 my-new-post"
  exit 1
}

# 引数が渡されていなければ使用方法を表示
if [ $# -eq 0 ]; then
  show_usage
fi

# スラッグを取得
SLUG=$1

# 現在の日付を取得
YEAR=$(date +"%Y")
DATE=$(date +"%Y%m%d")

# 日付付きのスラッグを作成
DATED_SLUG="${DATE}_${SLUG}"

# 記事を格納するディレクトリパス (日付付きではないパスをhugoコマンドに渡す)
POST_PATH="post/${SLUG}"

# 環境変数を設定してhugoコマンドを実行（HUGO_プレフィックス付き）
export HUGO_CUSTOM_SLUG="${SLUG}"
hugo new content --kind custom-post "${POST_PATH}/index.md"

# 作成された記事のパス
# 例: content/post/my-new-post
CREATED_PATH="content/${POST_PATH}"

# 日付付きのディレクトリ名
# 例: content/post/20210101_my-new-post
DATED_DIR="content/post/${DATED_SLUG}"

# 記事を日付付きのディレクトリにリネーム
if [ -d "${CREATED_PATH}" ]; then
  # まずリネーム
  mv "${CREATED_PATH}" "${DATED_DIR}"
  
  # 年ディレクトリを作成
  YEAR_DIR="content/post/${YEAR}"
  mkdir -p "${YEAR_DIR}"
  
  # 日付付きディレクトリを年ディレクトリに移動
  TARGET_PATH="${YEAR_DIR}/$(basename ${DATED_DIR})"
  mv "${DATED_DIR}" "${TARGET_PATH}"
  
  echo "記事を作成しました: ${TARGET_PATH}/index.md"
else
  echo "エラー: 記事が作成されませんでした"
  exit 1
fi
