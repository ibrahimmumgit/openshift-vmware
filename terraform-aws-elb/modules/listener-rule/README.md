<!-- BEGIN_TF_DOCS -->
# AWS Load Balancer Listener Rule Terraform module

Terraform module which creates AWS Load Balancer Listener Rule resources.

## Examples

See the **/examples** directory for working examples to reference

- [Basic](https://dev.azure.com/petronasvsts/PETRONAS_AWS_IAC_Module/_git/terraform-aws-elb?path=/modules/listener-rule/examples&version=GBmaster)

## Usage

### Basic

```hcl
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
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_lb_listener_rule.lb_listener_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_action"></a> [action](#input\_action) | (Required) Configuration block for default actions. | <pre>object({<br>    # (Optional) Order for the action. This value is required for rules with multiple actions. The action with the lowest value for order is performed first. Valid values are between 1 and 50000.<br>    order = optional(number)<br><br>    # Forward: single target<br>    # (Optional) ARN of the Target Group to which to route traffic. Specify only if type is forward and you want to route to a single target group. To route to one or more target groups, use a forward block instead.<br>    target_group_arn = optional(string)<br><br>    # Fixed response<br>    fixed_response = optional(object({<br>      # (Required) Content type. Valid values are 'text/plain', 'text/css', 'text/html', 'application/javascript' and 'application/json'.<br>      content_type = string<br>      # (Optional) Message body.<br>      message_body = optional(string)<br>      # (Optional) HTTP response code. Valid values are 2XX, 4XX, or 5XX<br>      status_code = optional(string)<br>    }))<br><br>    # Forward: weighted targets<br>    forward = optional(object({<br>      # (Required) Set of 1-5 target group blocks.<br>      target_groups = list(object({<br>        # (Required) ARN of the target group.<br>        arn = string<br>        # (Optional) Weight. The range is 0 to 999.<br>        weight = optional(number)<br>      }))<br><br>      stickiness = optional(object({<br>        # (Optional) Time period, in seconds, during which requests from a client should be routed to the same target group. The range is 1-604800 seconds (7 days)<br>        duration = optional(number)<br>        # (Optional) Whether target group stickiness is enabled<br>        enabled = optional(bool, false)<br>      }))<br>    }))<br><br>    # Redirect<br>    redirect = optional(object({<br>      # (Optional) HTTP redirect code. The redirect is either permanent (HTTP_301) or temporary (HTTP_302).<br>      status_code = optional(string, "HTTP_302")<br>      # (Optional) Hostname. This component is not percent-encoded. The hostname can contain #{host}. Defaults to #{host}.<br>      host = optional(string, "#{host}")<br>      # (Optional) Absolute path, starting with the leading "/". This component is not percent-encoded. The path can contain #{host}, #{path}, and #{port}. Defaults to /#{path}.<br>      path = optional(string, "/#{path}")<br>      # (Optional) Port. Specify a value from 1 to 65535 or #{port}. Defaults to #{port}.<br>      port = optional(string, "#{port}")<br>      # (Optional) Protocol. Valid values are HTTP, HTTPS, or #{protocol}. Defaults to #{protocol}.<br>      protocol = optional(string, "#{protocol}")<br>      # (Optional) Query parameters, URL-encoded when necessary, but not percent-encoded. Do not include the leading "?". Defaults to #{query}.<br>      query = optional(string, "#{query}")<br>    }))<br><br>  })</pre> | n/a | yes |
| <a name="input_authenticate_cognito"></a> [authenticate\_cognito](#input\_authenticate\_cognito) | (Optional) Information for creating an authenticate action using Cognito. | `any` | `null` | no |
| <a name="input_authenticate_oidc"></a> [authenticate\_oidc](#input\_authenticate\_oidc) | (Optional) Information for creating an authenticate action using OIDC. Required if type is authenticate-oidc | `any` | `null` | no |
| <a name="input_conditions"></a> [conditions](#input\_conditions) | (Required) A Condition block. Multiple condition blocks of different types can be set and all must be satisfied for the rule to match. | `any` | n/a | yes |
| <a name="input_listener_arn"></a> [listener\_arn](#input\_listener\_arn) | (Required, Forces New Resource) The ARN of the listener to which to attach the rule. | `string` | n/a | yes |
| <a name="input_module_depends_on"></a> [module\_depends\_on](#input\_module\_depends\_on) | (Optional) A list of external resources the module depends\_on. | `any` | `[]` | no |
| <a name="input_module_enabled"></a> [module\_enabled](#input\_module\_enabled) | (Optional) Whether to create resources within the module or not. | `bool` | `true` | no |
| <a name="input_module_tags"></a> [module\_tags](#input\_module\_tags) | (Optional) A map of tags that will be applied to all created resources that accept tags. Tags defined with 'module\_tags' can be overwritten by resource-specific tags. | `map(string)` | `{}` | no |
| <a name="input_priority"></a> [priority](#input\_priority) | (Optional) The priority for the rule between 1 and 50000. Leaving it unset will automatically set the rule with next available priority after currently existing highest rule. A listener can't have multiple rules with the same priority. | `number` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A map of tags to apply to the 'aws\_lb\_listener' resource. Default is {}. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_lb_listener_rule"></a> [lb\_listener\_rule](#output\_lb\_listener\_rule) | All outputs of the created 'aws\_lb\_listener\_rule' resource. |
| <a name="output_module_enabled"></a> [module\_enabled](#output\_module\_enabled) | Whether the module is enabled. |
| <a name="output_module_tags"></a> [module\_tags](#output\_module\_tags) | A map of tags that will be applied to all created resources that accept tags. |
<!-- END_TF_DOCS -->