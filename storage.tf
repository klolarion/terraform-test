# S3 버킷 생성
# - bucket: 전역적으로 유일한 버킷 이름 지정
# - lifecycle: 실수로 버킷이 삭제되는 것을 방지
resource "aws_s3_bucket" "main_s3" {
  # 버킷의 고유 이름 (전역적으로 유일해야 함)
  bucket = "my-test-bucket-klolarion"

  # 버킷 보호 설정
  lifecycle {
    # true로 설정하면 terraform destroy 명령으로도 버킷이 삭제되지 않음
    prevent_destroy = true
  }
}

# 서버 측 암호화 설정
# - AES256 알고리즘을 사용하여 버킷 내 모든 객체 암호화
# - 기본적으로 모든 새 객체에 암호화 적용
resource "aws_s3_bucket_server_side_encryption_configuration" "main_s3_encryption" {
  # 암호화를 적용할 버킷 ID
  bucket = aws_s3_bucket.main_s3.id
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
resource "aws_s3_bucket_versioning" "main_s3_versioning" {
  # 버전 관리를 적용할 버킷 ID
  bucket = aws_s3_bucket.main_s3.id
  versioning_configuration {
    # 버전 관리 상태 (Enabled 또는 Suspended)
    status = "Enabled"
  }
}

# 버킷 정책 설정
# - HTTPS를 통해서만 버킷에 접근 가능하도록 제한
# - HTTP를 통한 모든 접근 차단
resource "aws_s3_bucket_policy" "main_s3_policy" {
  # 정책을 적용할 버킷 ID
  bucket = aws_s3_bucket.main_s3.id
  # IAM 정책 문서 (JSON 형식)
  policy = jsonencode({
    # 정책 언어 버전
    Version = "2012-10-17"
    Statement = [
      {
        # 정책 효과 :: 아래 조건을 만족한다면 ? (요청 허용 또는 거부)
        Effect    = "Deny" 
        # 정책이 적용될 대상 (모든 사용자)
        Principal = "*"
        # 적용될 S3 작업 (모든 작업)
        Action    = "s3:*"
        # 정책이 적용될 리소스 (버킷과 버킷 내 모든 객체)
        Resource = [
          aws_s3_bucket.main_s3.arn,
          "${aws_s3_bucket.main_s3.arn}/*"
        ]
        # 정책 적용 조건
        Condition = {
          Bool = {
            # HTTPS가 아닌 연결을 거부
            "aws:SecureTransport" = "false"
          }
        }
      }
    ]
  })
}