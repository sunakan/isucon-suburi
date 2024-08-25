#!/bin/bash

set -eu

echo "----[ インデックス追加 ]"
echo "対象DB: isuconp"
echo "対象テーブル: comments"
echo "インデックス名: post_id_idx"
echo "カラム: post_id, created_at"
echo "----"

sudo mysql isuconp -e "alter table comments add index post_id_idx (post_id, created_at desc)"
