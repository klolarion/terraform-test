# ACM Certificate Data Source
data "aws_acm_certificate" "acm_certificate" {
  domain   = var.domain_name
  statuses = ["ISSUED"]
} 