variable "db_subnet_group_name" {
  description = "RDS 서브넷 그룹 이름"
  type        = string
  default     = "main"
}

variable "subnet_ids" {
  description = "RDS 서브넷 그룹에 포함될 서브넷 ID 목록"
  type        = list(string)
}

variable "db_identifier" {
  description = "RDS 인스턴스 식별자"
  type        = string
  default     = "terraform-rds"
}

variable "engine" {
  description = "데이터베이스 엔진"
  type        = string
  default     = "postgres"
}

variable "engine_version" {
  description = "데이터베이스 엔진 버전"
  type        = string
  default     = "17.2"
}

variable "instance_class" {
  description = "RDS 인스턴스 클래스"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "할당된 스토리지 크기 (GB)"
  type        = number
  default     = 20
}

variable "db_username" {
  description = "데이터베이스 마스터 사용자 이름"
  type        = string
}

variable "db_password" {
  description = "데이터베이스 마스터 비밀번호"
  type        = string
  sensitive   = true
}

variable "db_password_secret_name" {
  description = "데이터베이스 비밀번호가 저장된 Secrets Manager 시크릿 이름"
  type        = string
}

variable "security_group_ids" {
  description = "RDS 인스턴스에 적용될 보안 그룹 ID 목록"
  type        = list(string)
}

variable "snapshot_identifier" {
  description = "스냅샷 식별자"
  type        = string
  default     = "service-db-backup"
}

# 가장 최신 스냅샷을 찾는 데이터 소스
# data "aws_db_snapshot" "latest" {
#   db_instance_identifier = var.snapshot_identifier
#   most_recent           = true
# }

variable "restore_from_snapshot" {
  description = "스냅샷에서 복원 여부"
  type        = bool
  default     = false
}

variable "skip_final_snapshot" {
  description = "인스턴스 삭제 시 최종 스냅샷 생성을 건너뛸지 여부"
  type        = bool
  default     = false
}

variable "tags" {
  description = "리소스에 적용할 태그"
  type        = map(string)
  default     = {
    Name = "rds"
  }
}

variable "secret_manager_arn" {
  description = "데이터베이스 자격 증명이 저장된 Secrets Manager 시크릿 ARN"
  type        = string
}

variable "final_snapshot_identifier" {
  description = "최종 스냅샷 식별자"
  type        = string
}

# 시크릿 매니저에서 DB 자격 증명 가져오기
data "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = var.secret_manager_arn
}

# 가장 최신 스냅샷을 찾는 데이터 소스
# data "aws_db_snapshot" "latest" {
#   count = var.restore_from_snapshot ? 1 : 0
#   most_recent = true
#   db_instance_identifier = var.snapshot_identifier
#   include_shared = true
#   include_public = true
# }

