#!/bin/bash

set -eu

sudo -u mysql touch /var/log/mysql/mysql-slow.log

echo '----[ BEFORE ]'
echo -n '/var/log/mysql/mysql-slow.log の行数:'
sudo -u mysql cat /var/log/mysql/mysql-slow.log | wc -l
echo ''

echo '----[ LOG BACKUP ]'
sudo -u mysql mv /var/log/mysql/mysql-slow.log /var/log/mysql/mysql-slow.log.old
echo '/var/log/mysql/mysql-slow.log.oldにバックアップを取りました'
echo ''


echo '----[ RESTART ]'
# slow_query_logとlong_query_timeがある行を削除
sudo sed -i '/slow_query/d' /etc/mysql/mysql.conf.d/mysqld.cnf
sudo sed -i '/long_query_time/d' /etc/mysql/mysql.conf.d/mysqld.cnf
# slow_query_log: 有効化
# slow_query_log_file: ログ出力先
# long_query_time: 指定した秒数以上掛かったクエリをスローログとみなす
sudo echo 'slow_query_log      = 1' >> /etc/mysql/mysql.conf.d/mysqld.cnf
sudo echo 'slow_query_log_file = /var/log/mysql/mysql-slow.log' >> /etc/mysql/mysql.conf.d/mysqld.cnf
sudo echo 'long_query_time     = 0' >> /etc/mysql/mysql.conf.d/mysqld.cnf
sudo tail -n 3 /etc/mysql/mysql.conf.d/mysqld.cnf
sudo systemctl restart mysql
echo 'MySQLを再起動しました(スロークエリも有効化)'
echo ''

echo '----[ AFTER ]'
echo -n '/var/log/mysql/mysql-slow.log の行数:'
sudo -u mysql cat /var/log/mysql/mysql-slow.log | wc -l
