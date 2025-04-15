variable "alb_name" {
  description = "ALB 이름"
  type        = string
}


variable "alb_internal" {
  description = "ALB 내부 여부"
  type        = bool
}

variable "alb_load_balancer_type" {
  description = "ALB 유형"
  type        = string
}

variable "alb_security_group_ids" {
  description = "보안 그룹 ID"
  type        = list(string)
}

variable "alb_subnet_ids" {
  description = "서브넷 ID"
  type        = list(string)
}

variable "alb_enable_deletion_protection" {
  description = "삭제 보호 활성화 여부"
  type        = bool
}

variable "alb_tags" {
  description = "태그"
  type        = map(string)
}














