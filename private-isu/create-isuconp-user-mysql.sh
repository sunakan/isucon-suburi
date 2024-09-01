#!/bin/bash

set -eu

echo "----[ mysqlにどこからでも接続可能なisuconpを作成 ]"
sudo mysql isuconp -e "create user if not exists 'isuconp'@'%' identified by 'isuconp';"


echo "----[ isuconpにisuconpDB以下のテーブルへの全権限を追加 ]"
sudo mysql isuconp -e "grant all privileges on isuconp.* to 'isuconp'@'%'";


echo "----[ MySQLを公開する ]"
cat mysqld.cnf | sudo sed -i 's/^bind-address.*= 127\.0\.0\.1/bind-address = 0\.0\.0\.0/'


echo "----[ MySQLを再起動 ]"
sudo systemctl restart mysql
echo 'MySQLを再起動しました'
