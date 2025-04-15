# ALB 타겟 그룹 
resource "aws_lb_target_group" "target_group" {
  name        = var.target_group_name
  port        = var.target_group_port
  protocol    = var.target_group_protocol
  vpc_id      = var.target_group_vpc_id
  target_type = var.target_group_target_type

  health_check {
    enabled             = var.target_group_health_check.enabled
    interval            = var.target_group_health_check.interval
    path                = var.target_group_health_check.path
    port                = var.target_group_health_check.port
    protocol            = var.target_group_health_check.protocol
    timeout             = var.target_group_health_check.timeout
    healthy_threshold   = var.target_group_health_check.healthy_threshold
    unhealthy_threshold = var.target_group_health_check.unhealthy_threshold
    matcher             = var.target_group_health_check.matcher
  }

  tags = var.target_group_tags
}