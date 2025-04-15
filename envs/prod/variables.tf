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
variable "availability_zone_1" {
  description = "가용영역 1"
  type        = string
}

variable "availability_zone_2" {
  description = "가용영역 2"
  type        = string
}

# ALB 설정
variable "alb_name" {
  description = "ALB 이름"
  type        = string
}

variable "internal" {
  description = "ALB 내부 여부"
  type        = bool
}

variable "load_balancer_type" {
  description = "ALB 유형"
  type        = string
}

variable "security_group_ids" {
  description = "보안 그룹 ID"
  type        = list(string)
}

variable "subnet_ids" {
  description = "서브넷 ID"
  type        = list(string)
}

variable "enable_deletion_protection" {
  description = "삭제 보호 활성화 여부"
  type        = bool
}

variable "alb_tags" {
  description = "ALB 태그"
  type        = map(string)
}

# ALB 리스너 설정
variable "listener_port" {
  description = "리스너 포트"
  type        = number
}

variable "listener_protocol" {
  description = "리스너 프로토콜"
  type        = string
}

variable "listener_default_action_type" {
  description = "리스너 기본 액션 유형"
  type        = string
}

# ALB 타겟 그룹 설정
variable "alb_target_groups" {
  description = "타겟 그룹 설정"
  type        = list(object({
    name          = string
    port          = number
    protocol      = string
    target_type   = string
    health_check  = object({
      enabled             = bool
      healthy_threshold   = number
      interval            = number
      matcher            = string
      path               = string
      port               = string
      protocol           = string
      timeout            = number
      unhealthy_threshold = number
    })
    tags          = map(string)
  }))
}

# S3 Variables
variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "force_destroy" {
  description = "Allow bucket to be destroyed even if it contains objects"
  type        = bool
  default     = false
}

variable "versioning_enabled" {
  description = "Enable versioning for the bucket"
  type        = bool
  default     = true
}

variable "block_public_access" {
  description = "Block public access to the bucket"
  type        = bool
  default     = true
}

variable "s3_tags" {
  description = "Tags to apply to the S3 bucket"
  type        = map(string)
  default     = {}
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

variable "domain_name" {
  description = "도메인 이름"
  type        = string
}

# Route53 설정
variable "route53_zone_id" {
  description = "Route53 Zone ID"
  type        = string
}

# 시크릿 매니저 설정
variable "secret_manager_arn" {
  description = "Secrets Manager ARN"
  type        = string
}

# 스냅샷 이름 변수
variable "snapshot_identifier" {
  description = "스냅샷 이름"
  type        = string
}

variable "final_snapshot_identifier" {
  description = "최종 스냅샷 이름"
  type        = string
}

# 스냅샷 복원 여부 변수
variable "restore_from_snapshot" {
  description = "스냅샷에서 복원 여부"
  type        = bool
  default     = false
}

# # 시크릿 매니저에서 DB 자격 증명 가져오기
# data "aws_secretsmanager_secret_version" "db_credentials" {
#   secret_id = var.secret_manager_arn
# }

# # 가장 최신 스냅샷을 찾는 데이터 소스
# data "aws_db_snapshot" "latest" {
#   db_instance_identifier = var.snapshot_identifier
#   most_recent           = true
# }

# # ACM 설정
# variable "acm_certificate_arn" {
#   description = "ACM 인증서 ARN"
#   type        = string
# }

# RDS Variables
variable "rds_engine" {
  description = "RDS engine type"
  type        = string
  default     = "mysql"
}

variable "rds_engine_version" {
  description = "RDS engine version"
  type        = string
  default     = "8.0.35"
}

variable "rds_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "rds_allocated_storage" {
  description = "RDS allocated storage in GB"
  type        = number
  default     = 20
}

variable "rds_storage_type" {
  description = "RDS storage type"
  type        = string
  default     = "gp2"
}

variable "rds_db_name" {
  description = "RDS database name"
  type        = string
  default     = "service_db"
}

variable "rds_port" {
  description = "RDS port"
  type        = number
  default     = 3306
}

variable "rds_backup_retention_period" {
  description = "백업 보관 기간 (일)"
  type        = number
  default     = 7
}

variable "rds_skip_final_snapshot" {
  description = "Skip final snapshot when destroying RDS"
  type        = bool
  default     = false
}

variable "rds_restore_from_snapshot" {
  description = "스냅샷에서 복원 여부"
  type        = bool
  default     = false
}

variable "rds_multi_az" {
  description = "다중 AZ 설정 여부"
  type        = bool
  default     = false
}

variable "rds_publicly_accessible" {
  description = "외부 접근 가능 여부"
  type        = bool
  default     = false
}

variable "rds_storage_encrypted" {
  description = "스토리지 암호화 여부"
  type        = bool
  default     = true
}

variable "rds_apply_immediately" {
  description = "변경사항 즉시 적용 여부"
  type        = bool
  default     = true
}

# ECR Settings
variable "ecr_repository_name" {
  description = "Name of the ECR repository"
  type        = string
}

variable "ecr_force_delete" {
  description = "Whether to force delete the repository even if it contains images"
  type        = bool
  default     = false
}

variable "ecr_scan_on_push" {
  description = "Whether to scan images on push"
  type        = bool
  default     = true
}

variable "ecr_image_tag_mutability" {
  description = "The tag mutability setting for the repository"
  type        = string
  default     = "MUTABLE"
}

variable "ecr_keep_last_images" {
  description = "Number of images to keep in the repository"
  type        = number
  default     = 30
}

variable "ecr_tags" {
  description = "Tags to apply to the ECR repository"
  type        = map(string)
  default     = {}
}

# EC2 설정
variable "os_image_id" {
  description = "EC2 OS Image ID"
  type        = string
}

variable "instance_type" {
  description = "EC2 인스턴스 타입"
  type        = string
}

variable "service_instance_type" {
  description = "EC2 인스턴스 타입"
  type        = string
}

variable "sub_instance_type" {
  description = "EC2 인스턴스 타입"
  type        = string
}

# VPC 태그 설정
variable "vpc_tags" {
  description = "VPC 태그"
  type        = map(string)
  default     = {}
}

variable "certificate_arn" {
  description = "Certificate ARN"
  type        = string
}

variable "cloudflare_zone_id" {
  description = "Cloudflare Zone ID"
  type        = string
}
