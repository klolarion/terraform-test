# 기존 SSL 인증서 데이터 소스
data "aws_acm_certificate" "acm_certificate" {
  domain   = var.domain_name
  statuses = ["ISSUED"]
}

