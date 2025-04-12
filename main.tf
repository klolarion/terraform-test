# AWS Provider 설정
# - region: AWS 리전 설정 (variables.tf에서 정의)
provider "aws" {
  region = var.aws_region
}

# CloudFlare Provider 설정
provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
