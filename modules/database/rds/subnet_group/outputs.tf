output "subnet_group_name" {
  description = "생성된 RDS 서브넷 그룹의 이름"
  value       = aws_db_subnet_group.db_subnet_group.name
}

output "subnet_group_arn" {
  description = "생성된 RDS 서브넷 그룹의 ARN"
  value       = aws_db_subnet_group.db_subnet_group.arn
} 