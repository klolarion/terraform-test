output "target_group_arn" {
  description = "타겟 그룹 ARN"
  value       = aws_lb_target_group.target_group.arn
}

output "target_group_id" {
  description = "타겟 그룹 ID"
  value       = aws_lb_target_group.target_group.id
}

output "target_group_name" {
  description = "타겟 그룹 이름"
  value       = aws_lb_target_group.target_group.name
}

output "target_group_port" {
  description = "타겟 그룹 포트"
  value       = aws_lb_target_group.target_group.port
}

output "target_group_protocol" {
  description = "타겟 그룹 프로토콜"
  value       = aws_lb_target_group.target_group.protocol
}

output "target_group_vpc_id" {
  description = "타겟 그룹 VPC ID"
  value       = aws_lb_target_group.target_group.vpc_id
} 