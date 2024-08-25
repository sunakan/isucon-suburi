#!/bin/bash

set -eu

echo "----[ app.rbの上書き ]"
echo "FROM: /tmp/isucon-suburi/private-isu/files/09-app.rb"
echo "TO: /home/isucon/private_isu/webapp/ruby/app.rb"
echo "----"

sudo -u isucon cp /tmp/isucon-suburi/private-isu/files/09-app.rb /home/isucon/private_isu/webapp/ruby/app.rb

sudo systemctl restart isu-ruby
echo "isu-rubyを再起動しました"
