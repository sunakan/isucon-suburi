#!/bin/bash

set -eu

# --sort sum -r: レスポンスタイムの合計が大きい順で表示(昇順→-rでリバース)
# -m '/posts/[0-9]+,/@\w+,/image/\d+'でリクエストを正規表現でまとめてカウント
# 1つめ: /posts/0000や/posts/1234などのリクエストを "/posts/[0-9]+" にまとめてカウント
# 2つめ: /@fooや/@barなどのリクエストを "/@\w+" にまとめてカウント
# 3つめ: /image/0や/image/1などのリクエストを "/image/\d+" にまとめてカウント
# -o count,method,uri,min,avg,max,sum: カラムを指定
alp json \
  --sort sum -r \
  -m '/posts/[0-9]+,/@\w+,/image/\d+' \
  -o count,method,uri,min,avg,max,sum \
  --file /var/log/nginx/access.log
