resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr
  tags = { Name = "main-vpc" }
}


resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.public_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone = var.availability_zone
  tags = { Name = "public-subnet" }
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.private_subnet_cidr
  map_public_ip_on_launch = false
  availability_zone = var.availability_zone
  tags = { Name = "private-subnet" }
}



resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = { Name = "main-igw" }
}

resource "aws_eip" "nat" {
  domain = "vpc"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_nat_gateway" "main_nat" {
  allocation_id = aws_eip.nat.id
  subnet_id = aws_subnet.public_subnet.id
  tags = { Name = "main-nat"}
}




resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id
  tags = { Name = "public-rt" }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main_vpc.id
  tags = { Name = "private-rt" }
}

resource "aws_route" "public_route" {
  route_table_id = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.main_igw.id
}

resource "aws_route" "private_route" {
  route_table_id = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.main_nat.id
}

resource "aws_route_table_association" "public_rta" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private_rta" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}

# ################################################################################
# # ALB Security Group Configuration
# ################################################################################
# # Description: ALB Security Group 설정
# # - name: 보안 그룹 이름
# # - description: 보안 그룹 설명
# # - vpc_id: 위에서 생성한 VPC의 ID를 참조
# # - ingress: 인바운드 규칙 (HTTP 80 포트 허용)
# # - egress: 아웃바운드 규칙 (모든 트래픽 허용)
# ################################################################################

# resource "aws_security_group" "alb_sg" {
#   name        = "alb-sg"
#   description = "Security group for ALB"
#   vpc_id      = aws_vpc.main_vpc.id

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# } 