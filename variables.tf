# AWS 리전 설정 (서울 리전)
variable "aws_region" {
  description = "AWS 리전"
  type        = string
}

# VPC 설정
variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
}

variable "vpc_name" {
  description = "VPC 이름"
  type        = string
}

# 서브넷 설정
variable "public_subnet_cidr_c" {
  description = "퍼블릭 서브넷 CIDR (C 존)"
  type        = string
}

variable "public_subnet_cidr_a" {
  description = "퍼블릭 서브넷 CIDR (A 존)"
  type        = string
}

variable "private_subnet_cidr_c" {
  description = "프라이빗 서브넷 CIDR (C 존)"
  type        = string
}

variable "private_subnet_cidr_a" {
  description = "프라이빗 서브넷 CIDR (A 존)"
  type        = string
}

# 가용영역 설정
variable "availability_zone_c" {
  description = "가용영역 C"
  type        = string
}

variable "availability_zone_a" {
  description = "가용영역 A"
  type        = string
}

# S3 설정
variable "bucket_name" {
  description = "S3 버킷 이름"
  type        = string
}

variable "force_destroy" {
  description = "버킷 강제 삭제 여부"
  type        = bool
}

variable "prevent_destroy" {
  description = "버킷 삭제 방지 여부"
  type        = bool
}

variable "block_public_access" {
  description = "퍼블릭 액세스 차단 여부"
  type        = bool
}

variable "tags" {
  description = "리소스 태그"
  type        = map(string)
}

# ECR 설정
variable "repository_name" {
  description = "ECR 저장소 이름"
  type        = string
}

variable "image_tag_mutability" {
  description = "이미지 태그 변경 가능 여부"
  type        = string
}

variable "scan_on_push" {
  description = "푸시 시 스캔 여부"
  type        = bool
}

variable "max_image_count" {
  description = "최대 이미지 수"
  type        = number
}

# CloudFlare 설정
variable "cloudflare_api_token" {
  description = "CloudFlare API 토큰"
  type        = string
  sensitive   = true
}

variable "cloudflare_zone_id" {
  description = "CloudFlare Zone ID"
  type        = string
}

variable "domain_name" {
  description = "도메인 이름"
  type        = string
}

# Route53 설정
variable "route53_zone_id" {
  description = "Route53 Zone ID"
  type        = string
}

# Secrets Manager 설정
variable "secret_manager_arn" {
  description = "Secrets Manager ARN"
  type        = string
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

# 시크릿 매니저에서 DB 자격 증명 가져오기
data "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = var.secret_manager_arn
}

# 가장 최신 스냅샷을 찾는 데이터 소스
data "aws_db_snapshot" "latest" {
  db_instance_identifier = "terraform-rds"
  most_recent           = true
}

# ACM 설정
variable "acm_certificate_arn" {
  description = "ACM 인증서 ARN"
  type        = string
}

