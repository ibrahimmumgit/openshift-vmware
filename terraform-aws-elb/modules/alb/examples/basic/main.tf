module "alb" {
  source            = "../.."
  alb_name          = "PTAWSG-PROD-ALNG-API-ALB"
  subnet_ids        = [aws_subnet.az_01.id, aws_subnet.az_02.id, aws_subnet.az_03.id]
  is_internal       = true
  lb_type           = "application"
  app_prefix        = "ALNG"
  sg_id             = [aws_security_group.this.id]
  delete_protection = false # should turn this on for production!
}

################################################################################
# Listeners - listener submodule
################################################################################
module "listener" {
  source            = "../../../listener"
  load_balancer_arn = module.alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action = {
    type             = "forward"
    target_group_arn = module.tg_01.tg_arn
  }
}

################################################################################
# Target Groups - target-group submodule
################################################################################
module "tg_01" {
  source            = "../../../target-group"
  name              = "PTAWSG-PROD-ALNG-ALB-TG-01"
  port              = 80
  protocol          = "HTTP"
  target_type       = "ip"
  availability_zone = "all"
  vpc_id            = aws_vpc.this.id

  health_check = {
    interval            = 30
    protocol            = "HTTP"
    path                = "/"
    matcher             = "200-399"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 10
  }
}

module "tg_02" {
  source            = "../../../target-group"
  name              = "PTAWSG-PROD-ALNG-ALB-TG-02"
  port              = 80
  protocol          = "HTTP"
  target_type       = "ip"
  availability_zone = "all"
  vpc_id            = aws_vpc.this.id

  health_check = {
    interval            = 30
    protocol            = "HTTP"
    path                = "/"
    matcher             = "200-399"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 10
  }
}
