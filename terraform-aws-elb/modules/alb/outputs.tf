output "arn" {
  description = "Outputs ALB ARN"
  value       = aws_lb.app_alb.arn
}

output "dns_name" {
  description = "Outputs ALB DNS name"
  value       = aws_lb.app_alb.dns_name
}