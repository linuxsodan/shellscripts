#!/bin/bash

# １０文字のパスワードを生成して標準出力します

password_chars=""
regex=""

# オプションを解析
while getopts "dlu" opt; do
  case $opt in
    d)
      password_chars+="0-9"
      regex+=".*[0-9]"
      ;;
    l)
      password_chars+="a-z"
      regex+=".*[a-z]"
      ;;
    u)
      password_chars+="A-Z"
      regex+=".*[A-Z]"
      ;;
    \?)
      echo "Usage: $0 [-d] [-l] [-u]"
      exit 1
      ;;
  esac
done

# オプションがない場合はデフォルト、大文字、小文字、数字が含まれます
if [ -z "$regex" ]; then
  password_chars+="0-9a-zA-Z"
  regex=".*[A-Z].*[a-z].*[0-9].*"
fi

# urandomによりパスワード生成
PASSWORD=$(</dev/urandom tr -dc "$password_chars" | fold -w 10 | grep -E "$regex" | head -n 1)

echo "${PASSWORD}"

# パスワードをクリップボードに渡す場合
#echo "${PASSWORD}" | xsel -bi
