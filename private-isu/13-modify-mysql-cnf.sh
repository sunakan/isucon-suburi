#!/bin/bash

set -eu


echo "----[ mysqld.confの上書き ]"
echo "FROM: /tmp/isucon-suburi/private-isu/files/13-mysqld.cnf"
echo "TO: /etc/mysql/mysql.conf.d/mysql.cnf"
echo "----"

sudo cp /tmp/isucon-suburi/private-isu/files/13-mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf

sudo systemctl restart mysql
echo 'MySQLを再起動しました(スロークエリも有効化)'
echo ''
