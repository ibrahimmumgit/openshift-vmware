module "alb" {
  source            = "../alb"
  alb_name          = var.alb_name
  is_internal       = var.is_internal
  lb_type           = var.lb_type
  sg_id             = var.sg_id
  subnet_ids        = var.subnet_ids
  delete_protection = var.delete_protection
  idle_timeout      = var.idle_timeout
  tags              = merge({ Name = var.alb_name }, var.tags)
  app_prefix = "test"
}
 