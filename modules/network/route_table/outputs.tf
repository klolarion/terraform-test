output "route_table_id" {
  description = "라우트 테이블의 ID"
  value       = aws_route_table.route_table.id
}

output "route_table_arn" {
  description = "라우트 테이블의 ARN"
  value       = aws_route_table.route_table.arn
}
