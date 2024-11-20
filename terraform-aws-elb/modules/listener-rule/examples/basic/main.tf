module "lb_listener_rule_fixed" {
  source = "../.."

  listener_arn = module.listener.lb_listener.arn
  priority     = 1


  action = {
    type = "fixed-response"
    fixed_response = {
      content_type = "text/plain"
      status_code  = 200
      message_body = "HEALTHY"
    }
  }
  conditions = [{
    http_header = {
      http_header_name = "x-Gimme-Fixed-Response"
      values           = ["yes", "please", "right now"]
    }
  }]
}

module "lb_listener_rule_forward" {
  source = "../.."

  listener_arn = module.listener.lb_listener.arn
  priority     = 2

  action = {
    type             = "forward"
    target_group_arn = module.tg_01.tg_arn
  }
  conditions = [{
    query_string = {
      key   = "forward"
      value = "true"
    }
  }]
}

module "lb_listener_rule_weight" {
  source = "../.."

  listener_arn = module.listener.lb_listener.arn
  priority     = 3

  action = {
    type = "forward"
    forward = {
      target_groups = [
        {
          arn    = module.tg_01.tg_arn
          weight = 2
        },
        {
          arn    = module.tg_02.tg_arn
          weight = 1
        }
      ]
      stickiness = {
        enabled  = true
        duration = 3600
      }
    }
  }
  conditions = [{
    query_string = {
      key   = "weighted"
      value = "true"
    }
  }]
}

module "lb_listener_rule_redirect" {
  source = "../.."

  listener_arn = module.listener.lb_listener.arn
  priority     = 4

  action = {
    type = "redirect"
    redirect = {
      status_code = "HTTP_302"
      host        = "docs.aws.amazon.com"
      path        = "/elasticloadbalancing/latest/application/load-balancer-listeners.html"
      query       = ""
      protocol    = "HTTPS"
    }
  }
  conditions = [{
    query_string = {
      key   = "redirect"
      value = "true"
    }
  }]
}

################################################################################
# Supporting Resources
################################################################################
module "alb" {
  source            = "../../../alb"
  alb_name          = "PTAWSG-PROD-ALNG-API-ALB"
  subnet_ids        = [aws_subnet.az_01.id, aws_subnet.az_02.id, aws_subnet.az_03.id]
  is_internal       = true
  lb_type           = "application"
  app_prefix        = "ALNG"
  sg_id             = [aws_security_group.this.id]
  delete_protection = false # should turn this on for production!
}

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