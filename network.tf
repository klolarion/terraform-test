# VPC 생성
resource "aws_vpc" "main_vpc" {
  # VPC IP 주소 범위 설정
  cidr_block = var.vpc_cidr
  # VPC 이름 태그 설정
  tags       = { Name = "main-vpc" }
}

# Public 서브넷 생성 (인터넷 접근 가능)
resource "aws_subnet" "public_subnet" {
  # 서브넷이 생성될 VPC ID
  vpc_id                  = aws_vpc.main_vpc.id
  # 서브넷 IP 주소 범위
  cidr_block              = var.public_subnet_cidr
  # 서브넷에 생성되는 인스턴스에 자동으로 퍼블릭 IP 할당
  map_public_ip_on_launch = true
  # 서브넷이 생성될 가용 영역
  availability_zone       = var.availability_zone
  # 서브넷 이름 태그
  tags                    = { Name = "public-subnet" }
}

# Private 서브넷 생성 (인터넷 접근 불가)
resource "aws_subnet" "private_subnet" {
  # 서브넷이 생성될 VPC ID
  vpc_id                  = aws_vpc.main_vpc.id
  # 서브넷 IP 주소 범위
  cidr_block              = var.private_subnet_cidr
  # 서브넷에 생성되는 인스턴스에 퍼블릭 IP 자동 할당 비활성화
  map_public_ip_on_launch = false
  # 서브넷이 생성될 가용 영역
  availability_zone       = var.availability_zone
  # 서브넷 이름 태그
  tags                    = { Name = "private-subnet" }
}

# 인터넷 게이트웨이 생성
resource "aws_internet_gateway" "main_igw" {
  # 인터넷 게이트웨이가 연결될 VPC ID
  vpc_id = aws_vpc.main_vpc.id
  # 인터넷 게이트웨이 이름 태그
  tags   = { Name = "main-igw" }
}

# NAT Gateway용 EIP 생성
resource "aws_eip" "nat" {
  # EIP가 VPC에서 사용됨을 명시
  domain = "vpc"
  # EIP 교체 시 새 EIP를 먼저 생성 후 기존 EIP 제거
  lifecycle {
    create_before_destroy = true
  }
}

# NAT Gateway 생성
resource "aws_nat_gateway" "main_nat" {
  # NAT Gateway에 연결될 EIP ID
  allocation_id = aws_eip.nat.id
  # NAT Gateway가 생성될 서브넷 ID (반드시 Public 서브넷이어야 함)
  subnet_id     = aws_subnet.public_subnet.id
  # NAT Gateway 이름 태그
  tags          = { Name = "main-nat" }
}

# Public 라우트 테이블 생성
resource "aws_route_table" "public_rt" {
  # 라우트 테이블이 생성될 VPC ID
  vpc_id = aws_vpc.main_vpc.id
  # 라우트 테이블 이름 태그
  tags   = { Name = "public-rt" }
}

# Private 라우트 테이블 생성
resource "aws_route_table" "private_rt" {
  # 라우트 테이블이 생성될 VPC ID
  vpc_id = aws_vpc.main_vpc.id
  # 라우트 테이블 이름 태그
  tags   = { Name = "private-rt" }
}

# Public 라우트 설정 (인터넷 게이트웨이로 통신)
resource "aws_route" "public_route" {
  # 라우트가 추가될 라우트 테이블 ID
  route_table_id         = aws_route_table.public_rt.id
  # 목적지 IP 범위 (0.0.0.0/0는 모든 IP를 의미)
  destination_cidr_block = "0.0.0.0/0"
  # 인터넷 게이트웨이 ID (외부 인터넷 통신용)
  gateway_id             = aws_internet_gateway.main_igw.id
}

# Private 라우트 설정 (NAT Gateway로 통신)
resource "aws_route" "private_route" {
  # 라우트가 추가될 라우트 테이블 ID
  route_table_id         = aws_route_table.private_rt.id
  # 목적지 IP 범위 (0.0.0.0/0는 모든 IP를 의미)
  destination_cidr_block = "0.0.0.0/0"
  # NAT Gateway ID (Private 서브넷의 외부 통신용)
  nat_gateway_id         = aws_nat_gateway.main_nat.id
}

# Public 서브넷과 라우트 테이블 연결
resource "aws_route_table_association" "public_rta" {
  # 연결할 서브넷 ID
  subnet_id      = aws_subnet.public_subnet.id
  # 연결할 라우트 테이블 ID
  route_table_id = aws_route_table.public_rt.id
}

# Private 서브넷과 라우트 테이블 연결
resource "aws_route_table_association" "private_rta" {
  # 연결할 서브넷 ID
  subnet_id      = aws_subnet.private_subnet.id
  # 연결할 라우트 테이블 ID
  route_table_id = aws_route_table.private_rt.id
}
