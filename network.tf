################################################################################
# VPC Configuration
################################################################################
# Description: VPC 설정
# - cidr_block: VPC의 IP 주소 범위를 variables.tf에서 정의한 값으로 설정
# - default: 10.0.0.0/16
################################################################################

resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr
  tags = { Name = "main-vpc" }
}

################################################################################
# Public Subnet Configuration
################################################################################
# Description: Public Subnet 설정
# - vpc_id: 위에서 생성한 VPC의 ID를 참조
# - cidr_block: Public Subnet의 IP 주소 범위
# - map_public_ip_on_launch: 인스턴스 생성 시 자동으로 Public IP 할당
# - availability_zone: 가용 영역 설정
################################################################################

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.public_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone = var.availability_zone
  tags = { Name = "public-subnet" }
}

################################################################################
# Private Subnet Configuration
################################################################################
# Description: Private Subnet 설정
# - vpc_id: 위에서 생성한 VPC의 ID를 참조
# - cidr_block: Private Subnet의 IP 주소 범위
# - map_public_ip_on_launch: Public IP 할당하지 않음
# - availability_zone: 가용 영역 설정
################################################################################

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.private_subnet_cidr
  map_public_ip_on_launch = false
  availability_zone = var.availability_zone
  tags = { Name = "private-subnet" }
}

# ################################################################################
# # Internet Gateway Configuration
# ################################################################################
# # Description: Internet Gateway 설정
# # - vpc_id: 위에서 생성한 VPC의 ID를 참조
# ################################################################################

# resource "aws_internet_gateway" "main_igw" {
#   vpc_id = aws_vpc.main_vpc.id
#   tags = { Name = "main-igw" }
# }

# ################################################################################
# # Public Route Table Configuration
# ################################################################################
# # Description: Public Route Table 설정
# # - vpc_id: 위에서 생성한 VPC의 ID를 참조
# # - route: 인터넷 게이트웨이를 통해 외부 인터넷으로 통신하도록 설정
# ################################################################################

# resource "aws_route_table" "public_rt" {
#   vpc_id = aws_vpc.main_vpc.id
#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.main_igw.id
#   }
#   tags = { Name = "public-rt" }
# }

# ################################################################################
# # Public Route Table Association Configuration
# ################################################################################
# # Description: Public Route Table Association 설정
# # - subnet_id: Public Subnet의 ID를 참조
# # - route_table_id: 위에서 생성한 Public Route Table의 ID를 참조
# ################################################################################

# resource "aws_route_table_association" "public_rta" {
#   subnet_id      = aws_subnet.public_subnet.id
#   route_table_id = aws_route_table.public_rt.id
# }

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