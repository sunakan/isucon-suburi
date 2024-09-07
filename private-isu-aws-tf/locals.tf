locals {
  region     = "ap-northeast-1"
  name       = "private-isu"
  my_ip_cidr = "${data.http.my_ip.response_body}/32"
  #my_account_id = data.aws_caller_identity.current.account_id

  # NewRelicのSyntheticsのIPアドレス
  # ワシントン、ロンドン、東京、シドニーの4箇所に絞る(全てだと、RulesPerSecurityGroupLimitExceededで怒られる)
  # https://docs.newrelic.com/jp/docs/synthetics/synthetic-monitoring/administration/synthetic-public-minion-ips/#dynamic-ip-addresses
  # curl -s https://s3.amazonaws.com/nr-synthetics-assets/nat-ip-dnsname/production/ip-ranges.json | jq 'to_entries | map(.key as $key | .value | to_entries | map({key: ($key + "-" + ((.key | tonumber) + 1 | tostring)), value: .value})) | add | from_entries' | jq 'with_entries(select(.key | test("Washington|London|Tokyo|Sydney")))'
  newrelic_cidr = {
    "Washington, DC, USA-1" : "44.202.178.0/24",
    "Washington, DC, USA-2" : "44.202.180.0/23",
    "Washington, DC, USA-3" : "44.210.68.0/24",
    "Washington, DC, USA-4" : "44.210.110.0/25",
    "London, England, UK-1" : "13.40.201.0/24",
    "London, England, UK-2" : "13.40.208.0/25",
    "London, England, UK-3" : "13.41.206.128/25",
    "London, England, UK-4" : "13.41.206.64/26",
    "Tokyo, JP-1" : "35.77.208.0/24",
    "Tokyo, JP-2" : "35.79.233.64/26",
    "Tokyo, JP-3" : "35.79.233.128/28",
    "Sydney, AU-1" : "3.26.252.0/24",
    "Sydney, AU-2" : "3.26.245.128/25",
    "Sydney, AU-3" : "3.27.51.0/25"
  }
}

# http プロバイダーが必要
# 自分のIPアドレス取得
data "http" "my_ip" {
  url = "https://ipinfo.io/ip"
}
# data "aws_caller_identity" "current" {}
