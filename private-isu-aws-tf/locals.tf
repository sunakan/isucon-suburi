locals {
  region     = "ap-northeast-1"
  name       = "private-isu"
  my_ip_cidr = "${data.http.my_ip.response_body}/32"
  #my_account_id = data.aws_caller_identity.current.account_id
}

# http プロバイダーが必要
# 自分のIPアドレス取得
data "http" "my_ip" {
  url = "https://ipinfo.io/ip"
}
# data "aws_caller_identity" "current" {}
