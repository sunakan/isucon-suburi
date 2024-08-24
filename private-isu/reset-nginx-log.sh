#!/bin/bash

set -eu

echo '----[ BEFORE ]'
echo '行数: /var/log/nginx/access.log'
cat /var/log/nginx/access.log | wc -l
echo '行数: /var/log/nginx/error.log'
cat /var/log/nginx/error.log | wc -l

echo '----[ RESET ]'
mv /var/log/nginx/access.log var/log/nginx/access.log.old
echo 'DONE: mv /var/log/nginx/access.log var/log/nginx/access.log.old'
mv /var/log/nginx/error.log var/log/nginx/error.log.old
echo 'DONE: mv /var/log/nginx/error.log var/log/nginx/error.log.old'
systemctl reload nginx
echo 'DONE: systemctl reload nginx'

echo '----[ AFTER ]'
echo '行数: /var/log/nginx/access.log'
cat /var/log/nginx/access.log | wc -l
echo '行数: /var/log/nginx/error.log'
cat /var/log/nginx/error.log | wc -l
