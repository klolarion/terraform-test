output "nat_gateway_id" {
  description = "NAT Gateway ID"
  value       = aws_nat_gateway.nat_gateway.id
}

output "nat_eip_id" {
  description = "NAT Gateway EIP ID"
  value       = aws_eip.nat_eip.id
}

output "nat_name" {
  description = "NAT Gateway 이름"
  value       = aws_nat_gateway.nat_gateway.tags["Name"]
}





