# S3 버킷 생성
# - bucket: 전역적으로 유일한 버킷 이름 지정
# - lifecycle: 실수로 버킷이 삭제되는 것을 방지
resource "aws_s3_bucket" "bucket" {
  # 버킷의 고유 이름 (전역적으로 유일해야 함)
  bucket = var.bucket_name
  force_destroy = var.force_destroy

  tags = var.tags
}

# 서버 측 암호화 설정
# - AES256 알고리즘을 사용하여 버킷 내 모든 객체 암호화
# - 기본적으로 모든 새 객체에 암호화 적용
resource "aws_s3_bucket_server_side_encryption_configuration" "main_s3_encryption" {
  # 암호화를 적용할 버킷 ID
  bucket = aws_s3_bucket.bucket.id
  rule {
    # 기본 암호화 설정
    apply_server_side_encryption_by_default {
      # 암호화 알고리즘 (AES256 또는 aws:kms)
      sse_algorithm = "AES256"
    }
  }
}

# 버킷 버전 관리 설정
# - 객체의 모든 버전을 보존
# - 실수로 삭제되거나 덮어쓰기된 객체 복구 가능
resource "aws_s3_bucket_versioning" "versioning" {
  # 버전 관리를 적용할 버킷 ID
  bucket = aws_s3_bucket.bucket.id
  versioning_configuration {
    # 버전 관리 상태 (Enabled 또는 Suspended)
    status = var.versioning_enabled ? "Enabled" : "Disabled"
  }
}

# 버킷 정책 설정
# - HTTPS를 통해서만 버킷에 접근 가능하도록 제한
# - HTTP를 통한 모든 접근 차단
resource "aws_s3_bucket_policy" "main_s3_policy" {
  # 정책을 적용할 버킷 ID
  bucket = aws_s3_bucket.bucket.id
  # IAM 정책 문서 (JSON 형식)
  policy = jsonencode({
    # 정책 언어 버전 (IAM 정책의 버전)
    Version = "2012-10-17"
    Statement = [
      {
        # 정책 효과 :: 조건이 만족될 때 수행할 동작
        # - Allow: 요청 허용
        # - Deny: 요청 거부
        Effect    = "Deny" 
        
        # 정책이 적용될 대상 (Principal)
        Principal = "*"
        
        # 적용될 S3 작업 (Action)
        Action    = "s3:*"
        
        # 정책이 적용될 리소스 (Resource)
        Resource = [
          aws_s3_bucket.bucket.arn,
          "${aws_s3_bucket.bucket.arn}/*"
        ]
        
        # 정책 적용 조건 (Condition)
        # - 조건이 true일 때만 정책이 적용됨
        Condition = {
          Bool = {
            # aws:SecureTransport: 연결 프로토콜이 HTTPS인지 여부
            # - false: HTTP 연결
            # - true: HTTPS 연결
            "aws:SecureTransport" = "false" # HTTPS가 아닐때 -> Bool:true -> 요청 Deny 
          }
        }
      }
    ]
  })
}

resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = var.block_public_access
  block_public_policy     = var.block_public_access
  ignore_public_acls      = var.block_public_access
  restrict_public_buckets = var.block_public_access
}