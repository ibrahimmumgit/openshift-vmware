module "tg_http" {
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

module "tg_https" {
  source            = "../../../target-group"
  name              = "PTAWSG-PROD-ALNG-ALB-TG-02"
  port              = 443
  protocol          = "HTTPS"
  target_type       = "ip"
  availability_zone = "all"
  vpc_id            = aws_vpc.this.id

  health_check = {
    interval            = 30
    protocol            = "HTTPS"
    path                = "/"
    matcher             = "200-399"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 10
  }
}