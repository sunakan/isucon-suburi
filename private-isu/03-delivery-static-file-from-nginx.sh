#!/bin/bash

set -eu

echo "----[ jsやcss,faviconなどの静的ファイルをNginxに配信させ、キャッシュもする ]"

echo "----[ isucon.confの上書き ]"
echo "FROM: /tmp/isucon-suburi/private-isu/files/03-isucon.conf"
echo "TO: /etc/nginx/sites-available/isucon.conf"
echo "----"

sudo cp /tmp/isucon-suburi/private-isu/files/03-isucon.conf /etc/nginx/sites-available/isucon.conf

sudo systemctl reload nginx
echo "nginxを再起動しました"
