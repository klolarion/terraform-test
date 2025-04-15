output "instance_id" {
  description = "생성된 EC2 인스턴스의 ID"
  value       = aws_instance.instance.id
}

output "instance_arn" {
  description = "생성된 EC2 인스턴스의 ARN"
  value       = aws_instance.instance.arn
}






