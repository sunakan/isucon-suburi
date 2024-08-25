#!/bin/bash

set -eu

echo "----[ インデックス追加 ]"
echo "対象DB: isuconp"
echo "対象テーブル: comments"
echo "インデックス名: user_id_idx"
echo "カラム: user_id"
echo "----"

sudo mysql isuconp -e "alter table comments add index user_id_idx (user_id)"
