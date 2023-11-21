#!/bin/bash
if [[ "$(whoami)" == "root" ]];then
  echo "Error: need to root privileges."
  echo "Hint: run 'sudo $0'"
  exit 1
fi

# デフォルトで入っているDockerを削除
apt-get remove -y docker docker-engine docker.io containerd runc
apt-get update -y
apt-get install -y ca-certificates curl gnupg lsb-release

# Dockerリポジトリ登録
mkdir -p /etc/apt-get/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt-get/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt-get/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Dockerインストール
apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Dockerユーザ設定
usermod -aG docker vagrant
