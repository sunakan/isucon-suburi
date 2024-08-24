# 最新のAMIを利用するためのパラメータストア
# https://docs.aws.amazon.com/ja_jp/systems-manager/latest/userguide/parameter-store-public-parameters-ami.html
# awscliで取得する場合
# aws ssm get-parameters --names /aws/service/canonical/ubuntu/server/24.04/stable/current/arm64/hvm/ebs-gp3/ami-id --region ap-northeast-1
data "aws_ssm_parameter" "latest_ubuntu_ami" {
  name = "/aws/service/canonical/ubuntu/server/24.04/stable/current/arm64/hvm/ebs-gp3/ami-id"
}
resource "aws_iam_instance_profile" "this" {
  name = local.name
  role = aws_iam_role.this.name
}

resource "aws_instance" "app" {
  ami = data.aws_ssm_parameter.latest_ubuntu_ami.value
  # arm64
  # t4g.micro: 2vCPU, 1GiBメモリ
  # t4g.small: 2vCPU, 2GiBメモリ(2024年12月31日まで無料枠: https://aws.amazon.com/jp/ec2/faqs/#t4g-instances)
  # c7g.large: 2vCPU, 4GiBメモリ, USD 0.091/h
  # c7g.xlarge: 4vCPU, 8GiBメモリ, USD 0.1819/h
  instance_type        = "c7g.large"
  subnet_id            = aws_subnet.this.id
  iam_instance_profile = aws_iam_instance_profile.this.name
  # sudo tail -f /var/log/cloud-init-output.log
  user_data            = base64encode(file("cloud-init-app.yaml"))
  tags = {
    Name = "${local.name}-app"
  }
  root_block_device {
    # デフォルトは8GB
    # sqlの初期データ等であっという間に埋まってしまうため
    # 余裕を持ったボリュームサイズを指定
    volume_size = 30
    volume_type = "gp3"
  }
  vpc_security_group_ids = [aws_security_group.this.id]
}

resource "aws_instance" "benchmarker" {
  ami = data.aws_ssm_parameter.latest_ubuntu_ami.value
  instance_type        = "c7g.xlarge"
  subnet_id            = aws_subnet.this.id
  iam_instance_profile = aws_iam_instance_profile.this.name
  user_data            = base64encode(file("cloud-init-benchmarker.yaml"))
  tags = {
    Name = "${local.name}-benchmarker"
  }
  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }
  vpc_security_group_ids = [aws_security_group.this.id]
}
