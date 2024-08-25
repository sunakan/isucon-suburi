#!/bin/bash

set -eu

echo "----[ mysqlのデータを初期値より後に追加されたデータを全て削除 ]"

echo '----[ BEFORE ]'
sudo mysql isuconp -e "select 'comments', count(1) from comments;"
sudo mysql isuconp -e "select 'posts', count(1) from posts;"
sudo mysql isuconp -e "select 'users', count(1) from users;"
echo ''

echo '----[ DELETE ]'
echo "delete from comments where created_at > '2024-01-01';"
echo "delete from posts where created_at > '2024-01-01';"
echo "delete from users where created_at > '2024-01-01';"
echo ''
sudo mysql isuconp -e "delete from comments where created_at > '2024-01-01';"
sudo mysql isuconp -e "delete from posts where created_at > '2024-01-01';"
sudo mysql isuconp -e "delete from users where created_at > '2024-01-01';"

echo '----[ AFTER ]'
sudo mysql isuconp -e "select 'comments', count(1) from comments;"
sudo mysql isuconp -e "select 'posts', count(1) from posts;"
sudo mysql isuconp -e "select 'users', count(1) from users;"
