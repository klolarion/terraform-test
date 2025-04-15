# RDS DB 인스턴스 생성
resource "aws_db_instance" "db_instance" {
  identifier           = var.db_identifier
  engine              = var.engine
  engine_version      = var.engine_version
  instance_class      = var.instance_class
  allocated_storage   = var.allocated_storage
  db_subnet_group_name = var.db_subnet_group_name
  vpc_security_group_ids = var.security_group_ids
  
  # 자격 증명 설정
  username = var.db_username
  password = var.db_password

 
  
  
  snapshot_identifier = var.snapshot_identifier

  skip_final_snapshot = false
  final_snapshot_identifier = var.final_snapshot_identifier

  # 필수 설정
  backup_retention_period = var.backup_retention_period
  multi_az = var.multi_az
  publicly_accessible = var.publicly_accessible
  storage_encrypted = var.storage_encrypted
  apply_immediately = var.apply_immediately

  tags = var.tags

  # VPC 설정만 무시
  lifecycle {
    ignore_changes = [
      vpc_security_group_ids,
      db_subnet_group_name
    ]
  }
}
