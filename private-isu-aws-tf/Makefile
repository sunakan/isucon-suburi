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

.phony: login.app.isucon
login.app.isucon: ## appへisuconユーザーでlogin
	$(eval INSTANCE_ID := $(shell $(call instance_id,private-isu-app)))
	aws ssm start-session --target ${INSTANCE_ID} --document-name aws-startinteractivecommand --parameters command="sudo su - isucon"

.PHONY: login.benchmarker.isucon
login.benchmarker.isucon: ## benchmarkerへisuconユーザーでログイン
	$(eval INSTANCE_ID := $(shell $(call instance_id,private-isu-benchmarker)))
	aws ssm start-session --target ${INSTANCE_ID} --document-name AWS-StartInteractiveCommand --parameters command="sudo su - isucon"

.PHONY: reset-nginx-log
reset-nginx-log: ## app上でnginxのログをリセット(/tmp/isucon-suburiがあることが前提)
	$(eval INSTANCE_ID := $(shell $(call instance_id,private-isu-app)))
	aws ssm start-session --target ${INSTANCE_ID} --document-name AWS-StartNonInteractiveCommand --parameters '{"command": ["sudo bash /tmp/isucon-suburi/private-isu/reset-nginx-log.sh"]}'

.PHONY: reset-mysql-slow-query-log
reset-mysql-slow-query-log: ## app上でMySQLのスロークエリログを有効化&リセット(/tmp/isucon-suburiがあることが前提)
	$(eval INSTANCE_ID := $(shell $(call instance_id,private-isu-app)))
	aws ssm start-session --target ${INSTANCE_ID} --document-name AWS-StartNonInteractiveCommand --parameters '{"command": ["sudo bash /tmp/isucon-suburi/private-isu/reset-mysql-slow-query-log.sh"]}'

.PHONY: bench
bench: ## benchmarker実行
	$(eval INSTANCE_ID := $(shell $(call instance_id,private-isu-benchmarker)))
	$(eval APP_IP := $(shell aws ec2 describe-instances --filters "Name=tag:Name,Values=private-isu-app" "Name=instance-state-name,Values=running" --query 'Reservations[].Instances[].PrivateIpAddress' --output text))
	aws ssm start-session --target ${INSTANCE_ID} --document-name AWS-StartNonInteractiveCommand --parameters '{"command": ["sudo -u isucon /home/isucon/private_isu.git/benchmarker/bin/benchmarker -u /home/isucon/private_isu.git/benchmarker/userdata -t http://${APP_IP}/"]}'

.PHONY: reset-and-bench
reset-and-bench: ## ログ周りをリセットしてbenchmarkerを走らせる
	@make reset-nginx-log
	@make reset-mysql-slow-query-log
	@make bench

.PHONY: alp
alp: ## app上でnginxのログをalpで分析
	$(eval INSTANCE_ID := $(shell $(call instance_id,private-isu-app)))
	aws ssm start-session --target ${INSTANCE_ID} --document-name AWS-StartNonInteractiveCommand --parameters '{"command": ["alp json --file /var/log/nginx/access.log"]}'

.PHONY: pt-query-digest
pt-query-digest: ## app上でmysqlのスロークエリログを分析
	$(eval INSTANCE_ID := $(shell $(call instance_id,private-isu-app)))
	aws ssm start-session --target ${INSTANCE_ID} --document-name AWS-StartNonInteractiveCommand --parameters '{"command": ["sudo pt-query-digest /var/log/mysql/mysql-slow.log"]}'

.PHONY: show-processlist
show-processlist: ## app上でMySQLが処理しているSQLを表示
	$(eval INSTANCE_ID := $(shell $(call instance_id,private-isu-app)))
	aws ssm start-session --target ${INSTANCE_ID} --document-name AWS-StartNonInteractiveCommand --parameters '{"command": ["sudo mysql isuconp -e \"show processlist;\""]}'

.PHONY: show-isu-ruby-status
show-isu-ruby-status: ## app上でのisu-rubyのserviceの状態を確認
	$(eval INSTANCE_ID := $(shell $(call instance_id,private-isu-app)))
	aws ssm start-session --target ${INSTANCE_ID} --document-name AWS-StartNonInteractiveCommand --parameters '{"command": ["systemctl status isu-ruby"]}'

.PHONY: 01-add-comments-index
01-add-comments-index: ## appのdbのcommentsテーブルにindexを貼る
	$(eval INSTANCE_ID := $(shell $(call instance_id,private-isu-app)))
	aws ssm start-session --target ${INSTANCE_ID} --document-name AWS-StartNonInteractiveCommand --parameters '{"command": ["sudo mysql isuconp -e \"alter table comments add index post_id_idx (post_id, created_at desc)\""]}'

.PHONY: 02-increase-worker-process-for-isu-ruby
02-increase-worker-process-for-isu-ruby: ## appのワーカープロセスを増やす
	$(eval INSTANCE_ID := $(shell $(call instance_id,private-isu-app)))
	aws ssm start-session --target ${INSTANCE_ID} --document-name AWS-StartNonInteractiveCommand --parameters '{"command": ["sudo sed -i"]}'


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
# $(1): ec2 instanceの名前
define instance_id
  aws ec2 describe-instances --filters "Name=tag:Name,Values=$(1)" "Name=instance-state-name,Values=running" --query "Reservations[].Instances[].InstanceId" \
  | jq -r '. | .[0]'
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
