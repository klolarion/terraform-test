# AWS 리전 설정 (서울 리전)
variable "aws_region" {
  description = "AWS 리전"
  type        = string
  default     = "ap-northeast-2"
}

# VPC의 IP 주소 범위 설정
variable "vpc_cidr" {
  description = "VPC CIDR 블록"
  type        = string
  default     = "10.0.0.0/16"
}

# Public 서브넷의 IP 주소 범위 설정
variable "public_subnet_cidr" {
  description = "Public 서브넷 CIDR 블록"
  type        = string
  default     = "10.0.1.0/24"
}

# Private 서브넷의 IP 주소 범위 설정
variable "private_subnet_cidr" {
  description = "Private 서브넷 CIDR 블록"
  type        = string
  default     = "10.0.2.0/24"
}

# 인스턴스가 생성될 가용 영역 설정
variable "availability_zone" {
  description = "가용 영역"
  type        = string
  default     = "ap-northeast-2a"
}
