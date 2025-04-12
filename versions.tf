# Terraform 및 Provider 설정
terraform {
  # Terraform CLI 버전 제한
  # >= 1.0.0 : 1.0.0 이상의 버전만 사용
  # < 2.0.0  : 2.0.0 미만의 버전만 사용
  required_version = ">= 1.0.0, < 2.0.0"

  # 필요한 Provider 목록
  required_providers {
    # AWS Provider 설정
    aws = {
      # Provider 다운로드 위치
      source  = "hashicorp/aws"
      # AWS Provider 버전 제한
      # ~> 5.0 : 5.x 버전 사용 (5.1, 5.2 등 사용 가능, 6.0 이상 사용 불가)
      version = "~> 5.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
} 