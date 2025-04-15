output "load_balancer_arn" {
  description = "ALB ARN"
  value       = aws_lb.alb.arn
}

output "dns_name" {
  description = "ALB DNS 이름"
  value       = aws_lb.alb.dns_name
}

output "zone_id" {
  description = "ALB Zone ID"
  value       = aws_lb.alb.zone_id
}

output "id" {
  description = "ALB ID"
  value       = aws_lb.alb.id
}

output "alb_name" {
  description = "ALB 이름"
  value       = aws_lb.alb.name
}
