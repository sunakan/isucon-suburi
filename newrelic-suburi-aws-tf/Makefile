.PHONY: apply
apply: ## tofu apply
	tofu apply
	@echo 'しばらくしてから以下のコマンドで、provisioningの進捗を確認できます'
	@echo 'make login.app'
	@echo 'sudo tail -f /var/log/cloud-init-output.log'

.PHONY: recreate-ec2
recreate-ec2: ## tofu apply
	tofu apply -replace="aws_instance.app"

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

.PHONY: login
login: ## ssm用ユーザーでlogin
	$(eval INSTANCE_ID := $(shell $(call instance_id,newrelic-suburi)))
	aws ssm start-session --target ${INSTANCE_ID}

.PHONY: show-userdata
show-userdata: ## userdataを閲覧
	$(eval INSTANCE_ID := $(shell $(call instance_id,newrelic-suburi)))
	@aws ec2 describe-instance-attribute --instance-id ${INSTANCE_ID} --attribute userData | jq -r '.UserData.Value' | base64 -d

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
