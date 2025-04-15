output "security_group_id" {
  description = "생성된 보안 그룹의 ID"
  value       = aws_security_group.security_group.id
}

output "security_group_arn" {
  description = "생성된 보안 그룹의 ARN"
  value       = aws_security_group.security_group.arn
} 