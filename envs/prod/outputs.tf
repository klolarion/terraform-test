output "vpc_id" {
  value = module.vpc.vpc_id
}

output "alb_dns_name" {
  description = "ALB DNS 이름"
  value       = module.service_alb.dns_name
}

output "alb_zone_id" {
  description = "ALB Zone ID"
  value       = module.service_alb.zone_id
}

output "alb_arn" {
  description = "ALB ARN"
  value       = module.service_alb.load_balancer_arn
}

output "alb_id" {
  description = "ALB ID"
  value       = module.service_alb.id
}

output "alb_name" {
  description = "ALB의 이름"
  value       = module.service_alb.alb_name
}

