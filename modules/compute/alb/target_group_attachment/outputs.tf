output "attachment_id" {
  description = "타겟 그룹 첨부 ID"
  value       = aws_lb_target_group_attachment.target_group_attachment.id
}
