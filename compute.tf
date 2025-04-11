# EC2 인스턴스
resource "aws_instance" "app" {
  ami           = "ami-0c9c942bd7bf113a2"  # Ubuntu 24.04 LTS (ap-northeast-2)
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private_subnet_1.id

  vpc_security_group_ids = [aws_security_group.ec2.id]

  tags = {
    Name = "app-instance"
  }
}

# RDS 서브넷 그룹
resource "aws_db_subnet_group" "main" {
  name       = "main"
  subnet_ids = [
    aws_subnet.private_subnet_1.id,
    aws_subnet.private_subnet_2.id
  ]

  tags = {
    Name = "main-db-subnet-group"
  }
}

# RDS DB 인스턴스 생성
resource "aws_db_instance" "main" {
  identifier           = "terraform-rds"
  engine              = "mariadb"
  engine_version      = "10.6.20"
  instance_class      = "db.t3.micro"
  allocated_storage   = 20
  username           = jsondecode(data.aws_secretsmanager_secret_version.db_credentials.secret_string)["DB_USER"]
  password           = jsondecode(data.aws_secretsmanager_secret_version.db_credentials.secret_string)["DB_PASS"]
  db_subnet_group_name = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  
  # 스냅샷 설정
  snapshot_identifier = var.restore_from_snapshot && length(data.aws_db_snapshot.latest) > 0 ? data.aws_db_snapshot.latest.db_snapshot_identifier : null
  skip_final_snapshot = false
  final_snapshot_identifier = "terraform-backup-${formatdate("YYYYMMDD-hhmmss", timestamp())}"

  tags = {
    Name = "terraform-rds"
  }

  # VPC 설정만 무시
  lifecycle {
    ignore_changes = [
      vpc_security_group_ids,
      db_subnet_group_name
    ]
  }
}
