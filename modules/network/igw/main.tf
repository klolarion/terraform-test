# 인터넷 게이트웨이 생성
resource "aws_internet_gateway" "igw" {
  # 인터넷 게이트웨이가 연결될 VPC ID
  vpc_id = var.vpc_id
  # 인터넷 게이트웨이 이름 태그
  tags   = { Name = "igw-${var.vpc_name}" }
}

