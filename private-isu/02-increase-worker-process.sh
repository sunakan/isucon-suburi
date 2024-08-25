#!/bin/bash

set -eu

echo "----[ 上書き ]"
echo "FROM: /tmp/isucon-suburi/private-isu/files/02-unicorn_config.rb"
echo "TO: /home/isucon/private_isu/webapp/ruby/uncorn_config.rb"
echo "----"

sudo -u isucon cp /tmp/isucon-suburi/private-isu/files/02-unicorn_config.rb /home/isucon/private_isu/webapp/ruby/uncorn_config.rb
