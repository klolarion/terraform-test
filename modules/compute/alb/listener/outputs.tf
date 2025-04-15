output "listener_arn" {
  description = "리스너 ARN"
  value       = aws_lb_listener.listener.arn
}

output "listener_id" {
  description = "리스너 ID"
  value       = aws_lb_listener.listener.id
} 