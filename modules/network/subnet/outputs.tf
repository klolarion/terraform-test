output "subnet_id" {
  description = "생성된 서브넷의 ID"
  value       = aws_subnet.subnet.id
}

output "subnet_arn" {
  description = "생성된 서브넷의 ARN"
  value       = aws_subnet.subnet.arn
}

output "subnet_cidr_block" {
  description = "서브넷의 CIDR 블록"
  value       = aws_subnet.subnet.cidr_block
}

output "availability_zone" {
  description = "서브넷이 생성된 가용 영역"
  value       = aws_subnet.subnet.availability_zone
}

output "subnet_name" {
  description = "생성된 서브넷의 이름"
  value       = aws_subnet.subnet.tags["Name"]
}












