locals {
  region     = "ap-northeast-1"
  name       = "newrelic-suburi"
  my_ip_cidr = "${data.http.my_ip.response_body}/32"
  #my_account_id = data.aws_caller_identity.current.account_id

  # curl -s https://s3.amazonaws.com/nr-synthetics-assets/nat-ip-dnsname/production/ip-ranges.json | jq '."Tokyo, JP"'
  newrelic_cidrs = [
    "35.77.208.0/24",
    "35.79.233.64/26",
    "35.79.233.128/28",
  ]
}

# http プロバイダーが必要
# 自分のIPアドレス取得
data "http" "my_ip" {
  url = "https://ipinfo.io/ip"
}
# data "aws_caller_identity" "current" {}
