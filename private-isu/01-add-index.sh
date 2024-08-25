#!/bin/bash

set -eu

# テーブルにインデックスを貼る
#
# 対象DB: isuconp
# 対象テーブル: comments
# インデックス名: post_id_idx
# カラム: post_id, created_at
sudo mysql isuconp -e "alter table comments add index post_id_idx (post_id, created_at desc)"
