terraform {
  required_providers {
    # AWS Provider
    # https://registry.terraform.io/providers/hashicorp/aws/latest/docs
    # AWSのリソースを定義・操作するためのプロバイダー
    # 例: VPCを作成する
    aws = {
      source  = "hashicorp/aws"
      version = "5.63.0"
    }
    # HTTP Provider
    # https://registry.terraform.io/providers/hashicorp/http/latest/docs
    # HTTPリクエストを行い、結果を利用できるプロバイダー
    # 例: curl https://ipinfo.io/ip で自身の利用しているIPアドレスのみアクセス許可する
    http = {
      source  = "hashicorp/http"
      version = "3.4.4"
    }
  }
}
