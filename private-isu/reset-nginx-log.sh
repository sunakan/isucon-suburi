#!/bin/bash

rm -rf /var/log/nginx/*.log && echo '/var/log/nginx/*.logを削除しました'
systemctl reload nginx && echo 'nginxをreloadしました'

echo '/var/log/nginx/access.logの行数'
cat /var/log/nginx/access.log | wc -l
echo '/var/log/nginx/error.logの行数'
cat /var/log/nginx/error.log | wc -l
