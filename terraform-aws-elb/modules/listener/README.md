<!-- BEGIN_TF_DOCS -->
# AWS Load Balancer Listener Terraform module

Terraform module which creates AWS Load Balancer Listener resources.

## Examples

See the **/examples** directory for working examples to reference

- [Basic](https://dev.azure.com/petronasvsts/PETRONAS_AWS_IAC_Module/_git/terraform-aws-elb?path=/modules/listener/examples&version=GBmaster)

## Usage

### Basic

```hcl
module "listener" {
  source            = "../.."
  load_balancer_arn = module.alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action = {
    type             = "forward"
    target_group_arn = module.tg.tg_arn
  }
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

module "tg" {
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

| Name | Source | Version |
|------|--------|---------|
| <a name="module_lb_listener_rule"></a> [lb\_listener\_rule](#module\_lb\_listener\_rule) | ../listener-rule | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_lb_listener.listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener_certificate.certificate](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_certificate) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_certificates_arns"></a> [additional\_certificates\_arns](#input\_additional\_certificates\_arns) | (Required) The ARNs of the additional certificates to attach to the listener. | `set(string)` | `[]` | no |
| <a name="input_alpn_policy"></a> [alpn\_policy](#input\_alpn\_policy) | (Optional) Name of the Application-Layer Protocol Negotiation (ALPN) policy. Can be set if 'protocol' is set to 'TLS'. Valid values are 'HTTP1Only', 'HTTP2Only', 'HTTP2Optional', 'HTTP2Preferred', and 'None'. | `string` | `"None"` | no |
| <a name="input_certificate_arn"></a> [certificate\_arn](#input\_certificate\_arn) | (Optional) ARN of the default SSL server certificate. Exactly one certificate is required if the protocol is 'HTTPS'. | `string` | `null` | no |
| <a name="input_default_action"></a> [default\_action](#input\_default\_action) | (Required) Configuration block for default actions. | `any` | <pre>{<br>  "fixed_response": {<br>    "content_type": "plain/text",<br>    "message_body": "Nothing to see here!",<br>    "status_code": 418<br>  }<br>}</pre> | no |
| <a name="input_load_balancer_arn"></a> [load\_balancer\_arn](#input\_load\_balancer\_arn) | (Required, Forces New Resource) The ARN of the load balancer. | `string` | n/a | yes |
| <a name="input_module_depends_on"></a> [module\_depends\_on](#input\_module\_depends\_on) | (Optional) A list of external resources the module depends\_on. | `any` | `[]` | no |
| <a name="input_module_enabled"></a> [module\_enabled](#input\_module\_enabled) | (Optional) Whether to create resources within the module or not. | `bool` | `true` | no |
| <a name="input_module_tags"></a> [module\_tags](#input\_module\_tags) | (Optional) A map of tags that will be applied to all created resources that accept tags. Tags defined with 'module\_tags' can be overwritten by resource-specific tags. | `map(string)` | `{}` | no |
| <a name="input_port"></a> [port](#input\_port) | (Optional) Port on which the load balancer is listening. Not valid for Gateway Load Balancers. | `number` | `null` | no |
| <a name="input_protocol"></a> [protocol](#input\_protocol) | (Optional) Protocol for connections from clients to the load balancer. For Application Load Balancers, valid values are 'HTTP' and 'HTTPS'. For Network Load Balancers, valid values are 'TCP', 'TLS', 'UDP', and 'TCP\_UDP'. Not valid to use 'UDP' or 'TCP\_UDP' if dual-stack mode is enabled. Not valid for Gateway Load Balancers. | `string` | `null` | no |
| <a name="input_rules"></a> [rules](#input\_rules) | (Optional) A list of rules to be attached to the created listener. | `any` | `[]` | no |
| <a name="input_rules_tags"></a> [rules\_tags](#input\_rules\_tags) | (Optional) A map of tags to apply to all 'aws\_lb\_listener\_rule' resources. Default is {}. | `map(string)` | `{}` | no |
| <a name="input_ssl_policy"></a> [ssl\_policy](#input\_ssl\_policy) | (Optional) Name of the SSL Policy for the listener. Required if protocol is 'HTTPS' or 'TLS'. | `string` | `"ELBSecurityPolicy-2016-08"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A map of tags to apply to the 'aws\_lb\_listener' resource. Default is {}. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_certificates"></a> [certificates](#output\_certificates) | All outputs of the created 'aws\_lb\_listener\_certificate' resources. |
| <a name="output_lb_listener"></a> [lb\_listener](#output\_lb\_listener) | All outputs of the created 'aws\_lb\_listener' resource. |
| <a name="output_module_enabled"></a> [module\_enabled](#output\_module\_enabled) | Whether the module is enabled. |
| <a name="output_module_tags"></a> [module\_tags](#output\_module\_tags) | A map of tags that will be applied to all created resources that accept tags. |
| <a name="output_rules"></a> [rules](#output\_rules) | A map of all outputs of the resources created in the 'terraform-aws-lb-listener-rule' modules keyed by id. |
<!-- END_TF_DOCS -->