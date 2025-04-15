output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.vpc.id
}

output "vpc_arn" {
  description = "VPC ARN"
  value       = aws_vpc.vpc.arn
}

output "vpc_name" {
  description = "VPC Name"
  value       = aws_vpc.vpc.tags["Name"]
}
