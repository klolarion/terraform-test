variable "target_group_name" {
  description = "타겟 그룹 이름"
  type        = string
}

variable "target_group_port" {
  description = "타겟 그룹 포트"
  type        = number
}

variable "target_group_protocol" {
  description = "타겟 그룹 프로토콜"
  type        = string
  default     = "HTTP"
}

variable "target_group_vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "target_group_target_type" {
  description = "타겟 유형"
  type        = string
  default     = "instance"
}

variable "target_group_health_check" {
  description = "헬스 체크 설정"
  type = object({
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
  default = {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    matcher            = "200"
    path               = "/"
    port               = "traffic-port"
    protocol           = "HTTP"
    timeout            = 5
    unhealthy_threshold = 3
  }
}

variable "target_group_tags" {
  description = "태그"
  type        = map(string)
  default     = {}
}
