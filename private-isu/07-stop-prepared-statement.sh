#!/bin/bash

set -eu

echo "----[ Gemfilの上書き ]"
echo "FROM: /tmp/isucon-suburi/private-isu/files/07-Gemfile"
echo "TO: /home/isucon/private_isu/webapp/ruby/Gemfile"
echo "----"

sudo -u isucon cp /tmp/isucon-suburi/private-isu/files/07-Gemfile /home/isucon/private_isu/webapp/ruby/Gemfile

echo "----[ app.rbの上書き ]"
echo "FROM: /tmp/isucon-suburi/private-isu/files/07-app.rb"
echo "TO: /home/isucon/private_isu/webapp/ruby/app.rb"
echo "----"

sudo -u isucon cp /tmp/isucon-suburi/private-isu/files/07-app.rb /home/isucon/private_isu/webapp/ruby/app.rb

echo "----[ bundle install ]"

sudo su - isucon
cd /home/isucon/private_isu/webapp/ruby/
export PATH=${PATH}:/home/isucon/.local/ruby/bin/
/home/isucon/.local/ruby/bin/bundle install

sudo systemctl restart isu-ruby
echo "isu-rubyを再起動しました"
