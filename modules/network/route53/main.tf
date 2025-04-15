# Route53 호스팅 영역 생성
resource "aws_route53_zone" "main" {
  name = var.domain_name
  tags = var.tags
} 