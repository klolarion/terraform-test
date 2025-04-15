output "rule_arn" {
  description = "경로 기반 라우팅 규칙 ARN"
  value       = aws_lb_listener_rule.path_rule.arn
}

output "rule_id" {
  description = "경로 기반 라우팅 규칙 ID"
  value       = aws_lb_listener_rule.path_rule.id
}
