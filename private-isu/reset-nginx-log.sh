#!/bin/bash

set -eu

echo '----[ BEFORE ]'
echo -n '/var/log/nginx/access.log の行数:'
cat /var/log/nginx/access.log | wc -l
echo -n '/var/log/nginx/error.log の行数:'
cat /var/log/nginx/error.log | wc -l
echo ''

echo '----[ LOG BACKUP ]'
mv /var/log/nginx/access.log /var/log/nginx/access.log.old
echo '/var/log/nginx/access.log.oldにバックアップを取りました'
mv /var/log/nginx/error.log /var/log/nginx/error.log.old
echo '/var/log/nginx/error.log.oldにバックアップを取りました'
echo ''

echo '----[ RESTART ]'
systemctl reload nginx
echo 'Nginxを再起動しました'
echo ''

echo '----[ AFTER ]'
echo -n '/var/log/nginx/access.log の行数:'
cat /var/log/nginx/access.log | wc -l
echo -n '/var/log/nginx/error.log の行数:'
cat /var/log/nginx/error.log | wc -l
