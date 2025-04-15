# 경로 기반 라우팅 규칙
resource "aws_lb_listener_rule" "path_rule" {
  listener_arn = var.listener_arn
  priority     = var.listener_rule_priority

  action {
    type             = var.listener_rule_action_type
    target_group_arn = var.listener_rule_target_group_arn
  }

  condition {
    path_pattern {
      values = var.listener_rule_path_patterns
    }
  }
}