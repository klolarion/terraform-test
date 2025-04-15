output "db_instance_id" {
  description = "생성된 RDS 인스턴스의 ID"
  value       = aws_db_instance.db_instance.id
}

output "db_instance_arn" {
  description = "생성된 RDS 인스턴스의 ARN"
  value       = aws_db_instance.db_instance.arn
}

output "db_instance_endpoint" {
  description = "생성된 RDS 인스턴스의 엔드포인트"
  value       = aws_db_instance.db_instance.endpoint
}




