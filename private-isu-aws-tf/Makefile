.PHONY: apply
apply: ## tofu apply
	tofu apply
	@echo 'しばらくしてから以下のコマンドで、provisioningの進捗を確認できます'
	@echo 'make login.app'
	@echo 'sudo tail -f /var/log/cloud-init-output.log'
	@echo '完了したら以下のコマンドでサービスが動いているか確認してください'
	@echo 'systemctl status isu-ruby'
	@echo 'systemctl status nginx'

.PHONY: recreate-ec2
recreate-ec2: ## tofu apply
	tofu apply  -replace="aws_instance.app" -replace="aws_instance.benchmarker"

.PHONY: plan
plan: ## tofu plan
	tofu plan

.PHONY: destroy
destroy: ## tofu destroy
	tofu destroy

.PHONY: fmt
fmt: ## tofu fmt
	tofu fmt

.PHONY: ping
ping: ## AWSへの接続確認
	aws sts get-caller-identity

.phony: login.app
login.app: ## appへssm用ユーザーでlogin
	$(eval INSTANCE_ID := $(shell $(call instance_id,private-isu-app)))
	aws ssm start-session --target ${INSTANCE_ID}

.PHONY: login.benchmarker
login.benchmarker: ## benchmarkerへssm用ユーザーでログイン
	$(eval INSTANCE_ID := $(shell $(call instance_id,private-isu-benchmarker)))
	aws ssm start-session --target ${INSTANCE_ID}

.PHONY: open-app
open-app: ## open
	$(eval APP_IP := $(shell aws ec2 describe-instances --filters "Name=tag:Name,Values=private-isu-app" "Name=instance-state-name,Values=running" --query 'Reservations[].Instances[].PublicIpAddress' --output text))
	@open http://${APP_IP}/

.PHONY: create-isuconp-user
create-isuconp-user: ## isuconp ユーザーを作成
	$(call exec_command,private-isu-app,"sudo bash /tmp/isucon-suburi/private-isu/create-isuconp-user-mysql.sh")

.PHONY: create-newrelic-user
create-newrelic-user: ## newrelic ユーザーを作成
	$(call exec_command,private-isu-app,"sudo bash /tmp/isucon-suburi/private-isu/create-newrelic-user-mysql.sh")

.PHONY: reset-nginx-log
reset-nginx-log: ## app上でnginxのログをリセット(/tmp/isucon-suburiがあることが前提)
	$(call exec_command,private-isu-app,"sudo bash /tmp/isucon-suburi/private-isu/reset-nginx-log.sh")

.PHONY: reset-mysql-slow-query-log
reset-mysql-slow-query-log: ## app上でMySQLのスロークエリログを有効化&リセット(/tmp/isucon-suburiがあることが前提)
	$(call exec_command,private-isu-app,"sudo bash /tmp/isucon-suburi/private-isu/reset-mysql-slow-query-log.sh")

.PHONY: bench
bench: ## benchmarker実行
	$(eval APP_IP := $(shell aws ec2 describe-instances --filters "Name=tag:Name,Values=private-isu-app" "Name=instance-state-name,Values=running" --query 'Reservations[].Instances[].PrivateIpAddress' --output text))
	$(call exec_command,private-isu-benchmarker,"sudo -u isucon /home/isucon/private_isu.git/benchmarker/bin/benchmarker -u /home/isucon/private_isu.git/benchmarker/userdata -t http://${APP_IP}/")

.PHONY: reset-and-bench
reset-and-bench: ## ログ周りをリセットしてbenchmarkerを走らせる
	@make reset-nginx-log
	@make create-isuconp-user
	@make create-newrelic-user
	@make reset-mysql
	@make reset-mysql-slow-query-log
	@make bench

.PHONY: alp
alp: ## app上でnginxのログをalpで分析
	$(call exec_command,private-isu-app,"bash /tmp/isucon-suburi/private-isu/alp.sh")

.PHONY: pt-query-digest
pt-query-digest: ## app上でmysqlのスロークエリログを分析
	$(call exec_command,private-isu-app,"sudo pt-query-digest /var/log/mysql/mysql-slow.log")

.PHONY: show-isu-ruby-status
show-isu-ruby-status: ## app上でのisu-rubyのserviceの状態を確認
	$(call exec_command,private-isu-app,"systemctl status isu-ruby")

.PHONY: tail-cloud-init-output
tail-cloud-init-output: ## app,benchmarker上でのcloud-init-output.logをtail
	$(call exec_command,private-isu-app,"sudo tail /var/log/cloud-init-output.log")
	$(call exec_command,private-isu-benchmarker,"sudo tail /var/log/cloud-init-output.log")

.PHONY: reset-mysql
reset-mysql: ## mysqlを初期値以降にできたデータを削除
	$(call exec_command,private-isu-app,"bash /tmp/isucon-suburi/private-isu/reset-mysql.sh")

.PHONY: 01-add-comments-index
01-add-comments-index: ## appのdbのcommentsテーブルにindexを貼る
	$(call exec_command,private-isu-app,"bash /tmp/isucon-suburi/private-isu/01-add-index.sh")

.PHONY: 02-increase-worker-process-for-isu-ruby
02-increase-worker-process-for-isu-ruby: ## appのワーカープロセスを増やす
	$(call exec_command,private-isu-app,"bash /tmp/isucon-suburi/private-isu/02-increase-worker-process.sh")

.PHONY: 03-delivery-static-file-from-nginx
03-delivery-static-file-from-nginx: ## 静的ファイルをNginxで配信する
	$(call exec_command,private-isu-app,"bash /tmp/isucon-suburi/private-isu/03-delivery-static-file-from-nginx.sh")

.PHONY: 04-uploaded-img-to-static-file
04-uploaded-img-to-static-file: ## アップロード画像を静的にして、Nginxでキャッシュする
	$(call exec_command,private-isu-app,"bash /tmp/isucon-suburi/private-isu/04-uploaded-img-to-static-file.sh")

.PHONY: 05-use-join-in-sql
05-use-join-in-sql: ## SQLのJOINを使う
	$(call exec_command,private-isu-app,"bash /tmp/isucon-suburi/private-isu/05-use-join-in-sql.sh")

.PHONY: 06-increase-limits
06-increase-limits: ## ファイルディスクリプタの上限を増やす
	$(call exec_command,private-isu-app,"bash /tmp/isucon-suburi/private-isu/06-increase-limits.sh")

.PHONY: 07-stop-prepared-statement
07-stop-prepared-statement: ## プリペアドステートメントを使わない
	$(call exec_command,private-isu-app,"sudo -u isucon bash /tmp/isucon-suburi/private-isu/07-stop-prepared-statement.sh")

.PHONY: 08-add-comments-index
08-add-comments-index: ## appのdbのcommentsテーブルにindexを貼る
	$(call exec_command,private-isu-app,"bash /tmp/isucon-suburi/private-isu/08-add-index.sh")

.PHONY: 09-cache-sql-result
09-cache-sql-result: ## SQLの結果をキャッシュする
	$(call exec_command,private-isu-app,"bash /tmp/isucon-suburi/private-isu/09-cache-sql-result.sh")

.PHONY: 10-add-posts-index
10-add-posts-index: ## appのdbのpostsテーブルにindexを貼る
	$(call exec_command,private-isu-app,"bash /tmp/isucon-suburi/private-isu/10-add-index.sh")

.PHONY: 11-use-force-index
11-use-force-index: ## FORCE INDEXやSTRAIGHT_JOINを使う
	$(call exec_command,private-isu-app,"bash /tmp/isucon-suburi/private-isu/11-use-force-index.sh")

.PHONY: 12-use-openssl-gem
12-use-openssl-gem: ## openssl gemを使う
	$(call exec_command,private-isu-app,"bash /tmp/isucon-suburi/private-isu/12-use-openssl-gem.sh")

.PHONY: 13-modify-mysql-cnf
13-modify-mysql-cnf: ## mysqlの設定を変更
	$(call exec_command,private-isu-app,"bash /tmp/isucon-suburi/private-isu/13-modify-mysql-cnf.sh")

.PHONY: 14-add-newrelic
14-add-newrelic: ## Newrelicを追加
	$(call exec_command,private-isu-app,"bash /tmp/isucon-suburi/private-isu/14-add-newrelic.sh")

.PHONY: setup-all
setup-all: ## 01~全て適用する
	@make 01-add-comments-index
	@make 02-increase-worker-process-for-isu-ruby
	@make 03-delivery-static-file-from-nginx
	@make 04-uploaded-img-to-static-file
	@make 05-use-join-in-sql
	@make 06-increase-limits
	@make 07-stop-prepared-statement
	@make 08-add-comments-index
	@make 09-cache-sql-result
	@make 10-add-posts-index
	@make 11-use-force-index
	@make 12-use-openssl-gem
	@make 13-modify-mysql-cnf
	@make 14-add-newrelic

################################################################################
# Utility-Command help
################################################################################
.DEFAULT_GOAL := help

################################################################################
# マクロ
################################################################################
# Makefileの中身を抽出してhelpとして1行で出す
# $(1): Makefile名
# 使い方例: $(call help,{included-makefile})
define help
  grep -E '^[\.a-zA-Z0-9_-]+:.*?## .*$$' $(1) \
  | grep --invert-match "## non-help" \
  | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
endef

# Activeなec2インスタンスidを出す
# $(1): ec2 インスタンスの名前
define instance_id
  aws ec2 describe-instances \
    --filters "Name=tag:Name,Values=$(1)" "Name=instance-state-name,Values=running" \
    --query "Reservations[].Instances[].InstanceId" \
    --output text
endef

# ec2インスタンスに引数のコマンドを実行する
# $(1): ec2 インスタンスの名前
# $(2): 実行するコマンド
define exec_command
  $(eval INSTANCE_ID := $(shell $(call instance_id,$(1))))
  @echo "----"
  @echo "対象のEC2インスタンス名: $(1)"
  @echo "対象のEC2インスタンスID: ${INSTANCE_ID}"
  @echo "叩くコマンド: $(2)"
  @echo "----"

  @aws ssm start-session \
    --target "${INSTANCE_ID}" \
    --document-name AWS-StartNonInteractiveCommand \
    --parameters '{"command": [$(2)]}'
endef

################################################################################
# タスク
################################################################################
.PHONY: help
help: ## Make タスク一覧
	@echo '######################################################################'
	@echo '# Makeタスク一覧'
	@echo '# $$ make XXX'
	@echo '# or'
	@echo '# $$ make XXX --dry-run'
	@echo '######################################################################'
	@echo $(MAKEFILE_LIST) \
	| tr ' ' '\n' \
	| xargs -I {included-makefile} $(call help,{included-makefile})
