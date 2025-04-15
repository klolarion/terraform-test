output "acm_certificate_arn" {
  description = "ACM Certificate ARN"
  value       = data.aws_acm_certificate.acm_certificate.arn
}

output "acm_certificate_domain" {
  description = "ACM Certificate Domain"
  value       = data.aws_acm_certificate.acm_certificate.domain_name
}

output "acm_certificate_status" {
  description = "ACM Certificate Status"
  value       = data.aws_acm_certificate.acm_certificate.status
}

output "acm_certificate_validation_records" {
  description = "ACM Certificate Validation Records"
  value       = data.aws_acm_certificate.acm_certificate.validation_records
}






