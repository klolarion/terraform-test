output "igw_id" {
  description = "IGW ID"
  value       = aws_internet_gateway.igw.id
}

output "igw_arn" {
  description = "IGW ARN"
  value       = aws_internet_gateway.igw.arn
}

output "igw_name" {
  description = "IGW Name"
  value       = aws_internet_gateway.igw.tags["Name"]
}