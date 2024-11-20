<!-- BEGIN_TF_DOCS -->
# AWS Load Balancer Target Group Terraform module

Terraform module which creates AWS Load Balancer Target Group resources.

## Examples

See the **/examples** directory for working examples to reference

- [Basic](https://dev.azure.com/petronasvsts/PETRONAS_AWS_IAC_Module/_git/terraform-aws-elb?path=/modules/target-group/examples&version=GBmaster)

## Usage

### Basic

```hcl
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
| [aws_lb_target_group.target_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group_attachment.target_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zone"></a> [availability\_zone](#input\_availability\_zone) | n/a | `string` | `""` | no |
| <a name="input_enable_sticky"></a> [enable\_sticky](#input\_enable\_sticky) | n/a | `bool` | `false` | no |
| <a name="input_health_check"></a> [health\_check](#input\_health\_check) | Health Check configuration block | <pre>object({<br>    enabled             = optional(bool, true)<br>    healthy_threshold   = optional(number, 3)<br>    interval            = optional(number, 30)<br>    matcher             = optional(string)<br>    path                = optional(string)<br>    port                = optional(any) # string or number<br>    protocol            = optional(string)<br>    timeout             = optional(number, 5)<br>    unhealthy_threshold = optional(number, 3)<br>  })</pre> | <pre>{<br>  "healthy_threshold": 5,<br>  "interval": 30,<br>  "matcher": "200-302",<br>  "path": "/",<br>  "protocol": "HTTPS",<br>  "timeout": 5,<br>  "unhealthy_threshold": 2<br>}</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the target group. If omitted, Terraform will assign a random, unique name. This name must be unique per region per account, can have a maximum of 32 characters, must contain only alphanumeric characters or hyphens, and must not begin or end with a hyphen | `string` | `null` | no |
| <a name="input_port"></a> [port](#input\_port) | The port on which targets receive traffic | `number` | `null` | no |
| <a name="input_protocol"></a> [protocol](#input\_protocol) | Protocol the load balancer uses when performing health checks on targets. Valid values are `TCP`, `HTTP`, or `HTTPS`. Defaults to `HTTP` | `string` | `"HTTP"` | no |
| <a name="input_sticky_type"></a> [sticky\_type](#input\_sticky\_type) | n/a | `string` | `"source_ip"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags to assign to the resource | `map(string)` | `{}` | no |
| <a name="input_target_id"></a> [target\_id](#input\_target\_id) | The IDs of the target | `list(string)` | `[]` | no |
| <a name="input_target_type"></a> [target\_type](#input\_target\_type) | Type of target that you must specify when registering targets with this target group. Valid values are `instance`, `ip`, `lambda`, `alb`. Defaults to `instance` | `string` | `"instance"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | Identifier of the VPC in which to create the target group. Required when target\_type is `instance`, `ip` or `alb`. Does not apply when target\_type is `lambda` | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_tg_arn"></a> [tg\_arn](#output\_tg\_arn) | target group arn |
<!-- END_TF_DOCS -->