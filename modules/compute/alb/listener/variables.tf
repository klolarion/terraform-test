variable "load_balancer_arn" {
  description = "로드 밸런서 ARN"
  type        = string
}

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

variable "target_group_arn" {
  description = "타겟 그룹 ARN"
  type        = string
  default     = null
}

variable "listener_redirect_port" {
  description = "리다이렉트 포트"
  type        = number
  default     = null
}

variable "listener_redirect_protocol" {
  description = "리다이렉트 프로토콜"
  type        = string
  default     = null
}

variable "listener_redirect_status_code" {
  description = "리다이렉트 상태 코드"
  type        = string
  default     = null
}

variable "certificate_arn" {
  description = "인증서 ARN"
  type        = string
  default     = null
}










