#!/bin/bash -eu

# backup script for Kim General Secretary of the Workers' Party of Korea
# author: hoge
# collaborator: Mr. Komatsu

# バックアップのディレクトリ
BACKUP_DIR="/home/g21008ny/220a"
# このサイズ以上なら削除
MAX_SIZE=8000000

#### テスト用 ####

## 移動先

REMOVED_DIR="/home/g21008ny/220a-bkup"

##################

# 現在のサイズをとる関数と変数
NOWSIZE=0
_GetSize(){
  NOW_SIZE=$(du -s ${BACKUP_DIR} | cut -f1)
  echo ${NOW_SIZE}
}

# バックアップディレクトリをつくる
mkdir -p ${BACKUP_DIR} ${REMOVED_DIR}

echo "開始: スクリプト"

# _GetSize関数呼びだし、MAX_SIZE以上なら実施
while [[ $(_GetSize) > ${MAX_SIZE} ]]
do
  echo "サイズ以上: 現在のサイズ: $NOW_SIZE"

  # ls -tr で最終更新日・逆順でリストアップし、先頭だけ拾う
  OLDEST_ITEM="$(ls -tr ${BACKUP_DIR} | head -1 )"

  # BACKUP_DIRとくっつけて、絶対パスにする
  OLDEST_PATH="${BACKUP_DIR}/${OLDEST_ITEM}"

  # 削除（ディレクトリの場合は-r必要）
  echo "rm -f $OLDEST_PATH"

  # テスト: rmの代わりにmvで退避してみる
  mv ${OLDEST_PATH} ${REMOVED_DIR}
done

