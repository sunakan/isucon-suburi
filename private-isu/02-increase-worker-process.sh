#!/bin/bash

set -eu

echo "----[ 上書き ]"
echo "FROM: /tmp/isucon-suburi/private-isu/files/02-unicorn_config.rb"
echo "TO: /home/isucon/private_isu/webapp/ruby/unicorn_config.rb"
echo "----"

sudo -u isucon cp /tmp/isucon-suburi/private-isu/files/02-unicorn_config.rb /home/isucon/private_isu/webapp/ruby/unicorn_config.rb

sudo systemctl restart isu-ruby
echo "isu-rubyを再起動しました"
