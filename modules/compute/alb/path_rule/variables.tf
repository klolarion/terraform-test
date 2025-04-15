variable "listener_arn" {
  description = "리스너 ARN"
  type        = string
}

variable "listener_rule_priority" {
  description = "우선순위"
  type        = number
}

variable "listener_rule_action_type" {
  description = "액션 유형"
  type        = string
}

variable "listener_rule_target_group_arn" {
  description = "타겟 그룹 ARN"
  type        = string
}

variable "listener_rule_path_patterns" {
  description = "경로 패턴"
  type        = list(string)
}











