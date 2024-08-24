#!/bin/bash

rm -rf /var/log/nginx/*.log && echo '/var/log/nginx/*.logを削除しました'
systemctl reload nginx && echo 'nginxをreloadしました'
