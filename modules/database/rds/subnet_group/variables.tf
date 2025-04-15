variable "db_subnet_group_name" {
  description = "RDS 서브넷 그룹 이름"
  type        = string
}

variable "subnet_ids" {
  description = "RDS 서브넷 그룹에 포함될 서브넷 ID 목록"
  type        = list(string)
}

variable "tags" {
  description = "리소스에 적용할 태그"
  type        = map(string)
  default     = {}
} 