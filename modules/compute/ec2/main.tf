# EC2 인스턴스
resource "aws_instance" "instance" {
  ami           = var.instance_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  vpc_security_group_ids = var.security_group_ids

  tags = {
    Name = var.instance_name
  }
}