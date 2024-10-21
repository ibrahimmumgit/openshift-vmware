
# Target group for LB web traffic 443 for SKOIL
resource "aws_lb_target_group" "target_group" {
  name        = var.name
  port        = var.port
  protocol    = var.protocol
  target_type = var.target_type
  vpc_id      = var.vpc_id
  health_check {
    interval            = var.health_check.interval
    path                = var.health_check.path
    protocol            = var.health_check.protocol
    port                = try(var.health_check.port, null)
    timeout             = var.health_check.timeout
    healthy_threshold   = var.health_check.healthy_threshold
    unhealthy_threshold = var.health_check.unhealthy_threshold
    matcher             = var.health_check.matcher
  }
  tags = var.tags
}

resource "aws_lb_target_group_attachment" "target_attachment" {
  count             = length(var.target_id)
  target_group_arn  = aws_lb_target_group.target_group.arn
  target_id         = element(var.target_id, count.index)
  port              = var.port
  availability_zone = var.availability_zone
}
