#!/bin/bash
readonly SCRIPT_NAME="Linux雑談質問部屋 診断用スクリプト v20220716b"

# FIX: --output=fileを削除
readonly DF_COMMAND="df -h --output=source,fstype,itotal,iused,iavail,ipcent,size,used,avail,pcent,target"

source /etc/lsb-release

if [[ "$DISTRIB_ID" != "Ubuntu" ]]; then
  echo "このスクリプトはUbuntu以外サポートしていません．"
  echo "DISTRIB_ID = $DISTRIB_ID"
  exit 1
fi

wd="$(mktemp -d)"
trap 'rm -r '"$wd" exit

if ! which hwinfo > /dev/null 2>&1; then
  echo "hwinfoが入っていないため，ディスクに関する一部の情報を取得出来ません．"
  echo "管理者権限（sudo）を利用し，インストールしますか？(する場合は yes と入力)"
  echo "実行コマンド： sudo apt install hwinfo "
  read -r prompt
  if [[ "$prompt" == "yes" ]]; then
    # BUG: 14.04ではhwinfo存在しない．
    sudo apt install hwinfo
  fi
  unset prompt
fi

if ! which smartctl > /dev/null 2>&1; then
  echo "smartmontoolsが入っていないため，ディスクの健康状態に関する情報を取得出来ません．"
  echo "管理者権限（sudo）を利用し，インストールしますか？(する場合は yes と入力)"
  echo "実行コマンド： sudo apt install smartmontools "
  read -r prompt
  if [[ "$prompt" == "yes" ]]; then
    sudo apt install smartmontools
  fi
  unset prompt
fi

if which smartctl > /dev/null 2>&1; then
  echo "ディスクの健康状態を取得するため，事前に管理者権限の取得を試行します....(sudo)"
  sudo true
fi
echo "レポートを出力します．．．．"
sleep 2
clear
#############################
# ここから診断
time="$(date +%Y-%m-%d_%H.%M.%S)"
{

  echo "$SCRIPT_NAME"
  echo "実行日時: $time"
  echo "* CPU情報"
  grep 'model name' /proc/cpuinfo | uniq
  echo "* メモリ・キャッシュ情報"
  free -w
  echo "* ディスク情報"
  echo "** モデル情報"
  if which hwinfo > /dev/null 2>&1; then
    paste \
      <(hwinfo --disk | grep -e '^\s\+Model:' | cut -d: -f2) \
      <(hwinfo --disk | grep -e '^\s\+Device\ File:' | cut -d: -f2)
  else
    echo "> hwinfoが実行できませんでした．" #FIX: typo
  fi

  echo "** 主要マウントポイント"
  $DF_COMMAND | grep -e ' /$' -e ' /home' -e ' /tmp' | tee "$wd/df.txt"

  echo "** ディスク健康状態"

  if which smartctl > /dev/null 2>&1; then
    #FIX: blockDeviceから取得
    lsblk -r | awk ' $6 == "disk" {print $1}' > "$wd/disks.txt"
    while read -r name; do
      echo "**** $name"
      echo ""
      sudo smartctl -A "/dev/$name" | tail -n +7
    done < "$wd/disks.txt"
  else
    echo "> smartctlが実行できませんでした．"
  fi

} | tee "report.$time.txt"
echo "=========================="
echo "report.$time.txt に出力しました．"
