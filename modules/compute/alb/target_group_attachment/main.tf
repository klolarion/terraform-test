# 타겟 그룹에 EC2 인스턴스 연결 (8080)
resource "aws_lb_target_group_attachment" "target_group_attachment" {
  target_group_arn = var.target_group_arn
  target_id        = var.target_instance_id
  port             = var.target_group_port
}
