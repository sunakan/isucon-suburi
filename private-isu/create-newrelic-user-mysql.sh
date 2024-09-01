#!/bin/bash

set -eu

echo "----[ mysqlにlocalhostから接続可能なnewrelicユーザーを作成 ]"
sudo mysql isuconp -e "create user if not exists 'newrelic'@'localhost' identified by 'newrelic';"


echo "----[ newrelicにreplication client権限を追加 ]"
sudo mysql isuconp -e "grant replication client on *.* to 'newrelic'@'localhost';"


echo "----[ newrelicにselect権限を追加 ]"
sudo mysql isuconp -e "grant select on *.* to 'newrelic'@'localhost';"
