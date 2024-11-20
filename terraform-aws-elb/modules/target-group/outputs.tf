output "tg_arn" {
  description = "target group arn"
  value       = aws_lb_target_group.target_group.arn
}
