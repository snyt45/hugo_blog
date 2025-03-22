#!/bin/bash

# スクリプトの使用方法を表示する関数
function show_usage {
  echo "使用方法: $0 <スラッグ> [日付(YYYYMMDD)]"
  echo "例: $0 my-new-post"
  echo "例: $0 my-new-post 20250401"
  exit 1
}

# 引数が渡されていなければ使用方法を表示
if [ $# -eq 0 ]; then
  show_usage
fi

# スラッグを取得
SLUG=$1

# 日付を取得（指定があればそれを使用、なければ現在の日付）
if [ $# -ge 2 ] && [[ $2 =~ ^[0-9]{8}$ ]]; then
  # 指定された日付を使用
  DATE=$2
  # 年を抽出
  YEAR=${DATE:0:4}
else
  # 現在の日付を使用
  YEAR=$(date +"%Y")
  DATE=$(date +"%Y%m%d")
fi

# 日付の妥当性を検証
YEAR_PART=${DATE:0:4}
MONTH_PART=${DATE:4:2}
DAY_PART=${DATE:6:2}

# 簡易的な日付検証（月は1-12、日は1-31の範囲内であること）
if [ "$MONTH_PART" -lt 1 ] || [ "$MONTH_PART" -gt 12 ] || [ "$DAY_PART" -lt 1 ] || [ "$DAY_PART" -gt 31 ]; then
  echo "エラー: 無効な日付形式です。YYYYMMDD形式で指定してください（例: 20250401）"
  exit 1
fi

# ISO 8601形式の日時を生成（Hugoのフロントマターで使用）
ISO_DATE="${YEAR_PART}-${MONTH_PART}-${DAY_PART}T$(date +"%H:%M:%S%z")"

# 日付付きのスラッグを作成
DATED_SLUG="${DATE}_${SLUG}"

# 記事を格納するディレクトリパス (日付付きではないパスをhugoコマンドに渡す)
POST_PATH="post/${SLUG}"

# 環境変数を設定してhugoコマンドを実行（HUGO_プレフィックス付き）
export HUGO_CUSTOM_SLUG="${SLUG}"
export HUGO_CUSTOM_DATE="${ISO_DATE}"
hugo new content --kind custom-post "${POST_PATH}/index.md"

# 作成された記事のパス
CREATED_PATH="content/${POST_PATH}"

# 日付付きのディレクトリ名
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
  echo "日付: ${YEAR_PART}-${MONTH_PART}-${DAY_PART}"
else
  echo "エラー: 記事が作成されませんでした"
  exit 1
fi
