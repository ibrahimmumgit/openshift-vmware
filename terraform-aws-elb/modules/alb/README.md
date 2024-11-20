<!-- BEGIN_TF_DOCS -->
# AWS Load Balancer Terraform module

Terraform module which creates AWS Load Balancer resources.

## Examples

See the **/examples** directory for working examples to reference

- [Basic](https://dev.azure.com/petronasvsts/PETRONAS_AWS_IAC_Module/_git/terraform-aws-elb?path=/modules/alb/examples&version=GBmaster)

## Usage

### Basic

```hcl
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
| [aws_lb.app_alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_name"></a> [alb\_name](#input\_alb\_name) | The name of the LB | `string` | `null` | no |
| <a name="input_app_prefix"></a> [app\_prefix](#input\_app\_prefix) | Deprecate soon! Keeping this for now to avoid breaking change for v4 transition | `any` | n/a | yes |
| <a name="input_delete_protection"></a> [delete\_protection](#input\_delete\_protection) | If `true`, deletion of the load balancer will be disabled via the AWS API. This will prevent Terraform from deleting the load balancer. Defaults to `false` | `bool` | `false` | no |
| <a name="input_idle_timeout"></a> [idle\_timeout](#input\_idle\_timeout) | The time in seconds that the connection is allowed to be idle. Only valid for Load Balancers of type `application`. Defaults to `60` | `number` | `60` | no |
| <a name="input_is_internal"></a> [is\_internal](#input\_is\_internal) | If `true`, the LB will be internal. Defaults to `false` | `bool` | `false` | no |
| <a name="input_lb_type"></a> [lb\_type](#input\_lb\_type) | The type of load balancer to create. Possible values are `application`, `gateway`, or `network`. Defaults to `application` | `string` | `"application"` | no |
| <a name="input_sg_id"></a> [sg\_id](#input\_sg\_id) | A list of security group IDs to assign to the LB. Only valid for Load Balancers of type `application` or `network`. For load balancers of type `network` security groups cannot be added if none are currently present, and cannot all be removed once added. If either of these conditions are met, this will force a recreation of the resource | `set(string)` | `[]` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | A list of subnet IDs to attach to the LB. | `set(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resource | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | Outputs ALB ARN |
| <a name="output_dns_name"></a> [dns\_name](#output\_dns\_name) | Outputs ALB DNS name |
<!-- END_TF_DOCS -->