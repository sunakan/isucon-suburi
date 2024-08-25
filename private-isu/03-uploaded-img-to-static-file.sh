#!/bin/bash

set -eu

echo "----[ app.rbの上書き ]"
echo "FROM: /tmp/isucon-suburi/private-isu/files/03-app.rb"
echo "TO: /home/isucon/private_isu/webapp/ruby/app.rb"
echo "----"

sudo -u isucon cp /tmp/isucon-suburi/private-isu/files/03-app.rb /home/isucon/private_isu/webapp/ruby/app.rb

echo "----[ isucon.confの上書き ]"
echo "FROM: /tmp/isucon-suburi/private-isu/files/03-isucon.conf"
echo "TO: /etc/nginx/sites-available/isucon.conf"
echo "----"

sudo -u isucon cp /tmp/isucon-suburi/private-isu/files/03-isucon.conf /etc/nginx/sites-available/isucon.conf

sudo systemctl reload nginx
sudo systemctl restart isu-ruby
echo "nginxとisu-rubyを再起動しました"
