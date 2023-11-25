#!/bin/bash

# ---------------------------------
# デジタル時計を表示するスクリプト
# Ctrl + C で終了します
# ---------------------------------

hide_cursor="\e[?25l"
show_cursor="\e[?25h"
orange_color="\e[38;5;208m"
reset_color="\e[0m"

# スクリプトが終了するときにカーソルを表示する
trap "echo -e '${show_cursor}'; exit" EXIT  

# カーソルを非表示に
echo -e ${hide_cursor}

# 日本時間で時計表示
while :; do
    echo -ne "${orange_color}\t$(TZ='Asia/Tokyo' date +%H:%M:%S)${reset_color}"
    echo -ne "\r"     # カーソルを行の先頭に移動
    sleep 1
done
