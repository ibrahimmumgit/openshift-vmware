resource "aws_lb" "app_alb" {
  name                       = var.alb_name
  internal                   = var.is_internal
  load_balancer_type         = var.lb_type
  security_groups            = var.sg_id
  subnets                    = var.subnet_ids
  enable_deletion_protection = var.delete_protection
  idle_timeout               = var.idle_timeout
  tags                       = merge({ Name = var.alb_name }, var.tags)
}

