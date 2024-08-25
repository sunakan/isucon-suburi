#!/bin/bash

set -eu

echo "----[ limits.confの上書き ]"
echo "FROM: /tmp/isucon-suburi/private-isu/files/06-limits.conf"
echo "TO: /etc/security/limits.conf"
echo "----"

sudo cp /tmp/isucon-suburi/private-isu/files/06-limits.conf /etc/security/limits.conf
sudo chown 644 /etc/security/limits.conf

echo "isuconユーザーのファイルディスクリプタの上限を増やしました"
