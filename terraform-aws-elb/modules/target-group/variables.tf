variable "name" {
  description = "Name of the target group. If omitted, Terraform will assign a random, unique name. This name must be unique per region per account, can have a maximum of 32 characters, must contain only alphanumeric characters or hyphens, and must not begin or end with a hyphen"
  type        = string
  default     = null
}

variable "tags" {
  description = "Map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "Identifier of the VPC in which to create the target group. Required when target_type is `instance`, `ip` or `alb`. Does not apply when target_type is `lambda`"
  type        = string
  default     = null
}

variable "protocol" {
  description = "Protocol the load balancer uses when performing health checks on targets. Valid values are `TCP`, `HTTP`, or `HTTPS`. Defaults to `HTTP`"
  type        = string
  default     = "HTTP"
}

variable "target_type" {
  description = "Type of target that you must specify when registering targets with this target group. Valid values are `instance`, `ip`, `lambda`, `alb`. Defaults to `instance`"
  type        = string
  default     = "instance"
}

variable "availability_zone" {
  type    = string
  default = ""
}

variable "sticky_type" {
  type    = string
  default = "source_ip"
}

variable "enable_sticky" {
  type    = bool
  default = false
}

variable "health_check" {
  description = "Health Check configuration block"
  type = object({
    enabled             = optional(bool, true)
    healthy_threshold   = optional(number, 3)
    interval            = optional(number, 30)
    matcher             = optional(string)
    path                = optional(string)
    port                = optional(any) # string or number
    protocol            = optional(string)
    timeout             = optional(number, 5)
    unhealthy_threshold = optional(number, 3)
  })
  default = {
    interval            = 30
    path                = "/"
    protocol            = "HTTPS"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200-302"
  }
}

variable "port" {
  description = "The port on which targets receive traffic"
  type        = number
  default     = null
}

variable "target_id" {
  description = "The IDs of the target"
  type        = list(string)
  default     = []
}
