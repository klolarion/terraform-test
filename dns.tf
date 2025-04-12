# 기존 Route53 호스팅 영역 데이터 소스
# ::Cloudflare WAF 사용 시 주석 처리
# data "aws_route53_zone" "main" {
#   zone_id = var.route53_zone_id
# }

# 기존 SSL 인증서 데이터 소스
data "aws_acm_certificate" "main" {
  domain   = var.domain_name
  statuses = ["ISSUED"]
}

# # ALB를 위한 A 레코드
# resource "aws_route53_record" "main" {
#   zone_id = data.aws_route53_zone.main.zone_id
#   name    = var.domain_name
#   type    = "A"

#   alias {
#     name                   = aws_lb.app.dns_name
#     zone_id                = aws_lb.app.zone_id
#     evaluate_target_health = true
#   }
# }
