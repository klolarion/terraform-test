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
variable "private_subnet_cidr_c" {
  description = "Private 서브넷 CIDR 블록"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_subnet_cidr_a" {
  description = "Private 서브넷 CIDR 블록"
  type        = string
  default     = "10.0.3.0/24"
}

# 인스턴스가 생성될 가용 영역 설정
variable "availability_zone_c" {
  description = "가용 영역"
  type        = string
  default     = "ap-northeast-2c"
}

variable "availability_zone_a" {
  description = "가용 영역"
  type        = string
  default     = "ap-northeast-2a"
}


# 스냅샷 이름 변수
variable "snapshot_name" {
  description = "스냅샷 이름"
  type        = string
  default     = "terraform-backup"
}

# 스냅샷 복원 여부 변수
variable "restore_from_snapshot" {
  description = "스냅샷에서 복원 여부"
  type        = bool
  default     = false
}

# 시크릿 매니저 ARN 변수
variable "secret_manager_arn" {
  description = "시크릿 매니저 ARN"
  type        = string
  default     = ""
}

# 시크릿 매니저에서 DB 자격 증명 가져오기
data "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = var.secret_manager_arn
}

# 가장 최신 스냅샷을 찾는 데이터 소스
data "aws_db_snapshot" "latest" {
  db_instance_identifier = "terraform-rds"
  most_recent           = true
}

