#!/bin/bash

set -eu

echo "----[ インデックス追加 ]"
echo "対象DB: isuconp"
echo "対象テーブル: posts"
echo "インデックス名: posts_user_idx"
echo "カラム: user_id, created_at"
echo "----"

sudo mysql isuconp -e "alter table posts add index posts_user_idx (user_id, created_at desc)"
