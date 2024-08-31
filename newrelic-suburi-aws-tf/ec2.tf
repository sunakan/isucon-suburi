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
  # t4g.small: 2vCPU, 2GiBメモリ(2024年12月31日まで無料枠: https://aws.amazon.com/jp/ec2/faqs/#t4g-instances)
  instance_type        = "t4g.small"
  subnet_id            = aws_subnet.this.id
  iam_instance_profile = aws_iam_instance_profile.this.name
  # sudo tail -f /var/log/cloud-init-output.log
  user_data = base64encode(templatefile("cloud-init.yaml.tpl", {
    hostname = local.name
  }))
  tags = {
    Name = "${local.name}"
  }
  root_block_device {
    # デフォルトは8GB
    volume_size = 20
    volume_type = "gp3"
  }
  vpc_security_group_ids = [aws_security_group.this.id]
}
