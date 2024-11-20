#Variables referenced in ALB root module
 
variable "alb_name" {
  description = "The name of the LB"
  type        = string
  default     = null
}
 
variable "is_internal" {
  description = "If `true`, the LB will be internal. Defaults to `false`"
  type        = bool
  default     = false
}
 
variable "lb_type" {
  description = "The type of load balancer to create. Possible values are `application`, `gateway`, or `network`. Defaults to `application`"
  type        = string
  default     = "application"
}
 
variable "sg_id" {
  description = "A list of security group IDs to assign to the LB. Only valid for Load Balancers of type `application` or `network`. For load balancers of type `network` security groups cannot be added if none are currently present, and cannot all be removed once added. If either of these conditions are met, this will force a recreation of the resource"
  type        = set(string)
  default     = []
}
 
variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}
variable "subnet_ids" {
  description = "A list of subnet IDs to attach to the LB."
  type        = set(string)
  default     = []
}
 
variable "delete_protection" {
  description = "If `true`, deletion of the load balancer will be disabled via the AWS API. This will prevent Terraform from deleting the load balancer. Defaults to `false`"
  type        = bool
  default     = false
}
 
variable "idle_timeout" {
  description = "The time in seconds that the connection is allowed to be idle. Only valid for Load Balancers of type `application`. Defaults to `60`"
  type        = number
  default     = 60
}
 
# Unused variable, keeping this for now to avoid breaking change for v4 transition
variable "app_prefix" {
  description = "Deprecate soon! Keeping this for now to avoid breaking change for v4 transition"
  type        = string
  default     = "Deprecated"
}
 
# variable "access_key" {
#   type        = string
#   sensitive   = true
# }
 
# variable "secret_key" {
#   type        = string
#   sensitive   = true
# }
 
variable "region" {
  type        = string
  sensitive   = true
  default     = "us-east-1"
}
 
variable "target_groups" {
  description = "A list of target group configurations."
  type        = list(object({
    name              = string
    port              = number
    protocol          = string
    target_type       = string
    health_check      = optional(any)
    tags              = optional(map(string))
    target_id         = optional(string)
    availability_zone = optional(string)
  }))
  default = null
}
 
variable "vpc_id" {
  description = "The ID of the VPC where the target groups will be created."
  type        = string
  default     = null
}
 
variable "listeners" {
  description = "A list of listener configurations."
  type        = list(object({
    port                         = number
    protocol                     = string
    alpn_policy                  = optional(string)
    ssl_policy                   = optional(string)
    certificate_arn              = optional(string)
    default_action               = map(any)
    module_tags                  = optional(map(string))
    tags                         = optional(map(string))
    module_depends_on            = optional(list(any))
    additional_certificates_arns = optional(list(string))
    rules                        = optional(list(any))  # Assuming 'rules' is a list of objects
  }))
  default = null
}