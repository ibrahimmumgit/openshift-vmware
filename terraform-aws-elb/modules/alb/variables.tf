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
}

