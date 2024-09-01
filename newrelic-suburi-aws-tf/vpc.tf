#
# VPC
# InternetGateWayとRouteTableで外につながるパスを設定
#
resource "aws_vpc" "this" {
  cidr_block           = "192.168.0.0/16"
  enable_dns_support   = true # DNSサポートを有効化
  enable_dns_hostnames = true # DNSホスト名を有効化
  tags = {
    Name = local.name
  }
}
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = local.name
  }
}
resource "aws_route_table" "this" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
  tags = {
    Name = local.name
  }
}

#
# VPCサブネット
#
resource "aws_subnet" "this" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "192.168.1.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "${local.name}-az-1a"
  }
}

#
# サブネットとルートテーブルを関連付け
#
resource "aws_route_table_association" "this" {
  subnet_id      = aws_subnet.this.id
  route_table_id = aws_route_table.this.id
}

#
# セキュリティグループ
#
resource "aws_security_group" "this" {
  name   = local.name
  vpc_id = aws_vpc.this.id
  tags = {
    Name = local.name
  }
}
# 出ていく通信を全許可
resource "aws_vpc_security_group_egress_rule" "this" {
  security_group_id = aws_security_group.this.id
  from_port         = -1
  to_port           = -1
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
  tags = {
    Name = local.name
  }
}
# 自身のCIDRから入ってくる通信を全許可
resource "aws_vpc_security_group_ingress_rule" "this" {
  security_group_id = aws_security_group.this.id
  from_port         = -1
  to_port           = -1
  ip_protocol       = "-1"
  cidr_ipv4         = "192.168.0.0/16"
  tags = {
    Name = local.name
  }
}
# (テザリングなど)自分のIPアドレスからの全てのアクセス許可
resource "aws_vpc_security_group_ingress_rule" "allow_from_myip" {
  security_group_id = aws_security_group.this.id
  from_port         = -1
  to_port           = -1
  ip_protocol       = "-1"
  cidr_ipv4         = local.my_ip_cidr
  tags = {
    Name = local.name
  }
}

# NewRelicが公開しているIPアドレスからの全てのアクセス許可
# todo: 絞る
resource "aws_vpc_security_group_ingress_rule" "allow_from_newrelic" {
  for_each = toset(local.newrelic_cidrs)
  security_group_id = aws_security_group.this.id
  from_port         = -1
  to_port           = -1
  ip_protocol       = "-1"
  cidr_ipv4         = each.key
  tags = {
    Name = "allow-from-newrelic-${index(local.newrelic_cidrs, each.key) + 1}"
  }
}
