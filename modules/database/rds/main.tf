# RDS DB 인스턴스 생성
resource "aws_db_instance" "db_instance" {
  identifier           = var.db_identifier
  engine              = var.engine
  engine_version      = var.engine_version
  instance_class      = var.instance_class

  allocated_storage   = var.allocated_storage
  username = var.db_username
  password = var.db_password
  db_subnet_group_name = var.db_subnet_group_name
  vpc_security_group_ids = var.security_group_ids
  
  skip_final_snapshot = false
  final_snapshot_identifier = var.final_snapshot_identifier

  tags = var.tags

  # VPC 설정만 무시
  lifecycle {
    ignore_changes = [
      vpc_security_group_ids,
      db_subnet_group_name
    ]
  }
}
