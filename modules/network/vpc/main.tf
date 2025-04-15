resource "aws_vpc" "vpc" {
  # VPC IP 주소 범위 설정
  cidr_block = var.cidr_block
  # VPC 이름 태그 설정
  tags       = { Name = var.vpc_name }
}