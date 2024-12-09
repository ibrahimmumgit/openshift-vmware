/*
variable "nat_rule_name" {
  description = "The name of the LB"
  type        = string
  default     = null
}
variable "resource_group_name" {
  description = "The name of the LB"
  type        = string
  default     = null
}
variable "loadbalancer_id" {
  description = "The name of the LB"
  type        = string
  default     = null
}
variable "frontend_name" {
  description = "The name of the LB"
  type        = string
  default     = null
}
variable "protocol" {
  description = "The name of the LB"
  type        = string
  default     = null
}
variable "frontend_port" {
  description = "The name of the LB"
  type        = string
  default     = null
 # validation {
 #   condition = (var.frontend_port_start != null && var.frontend_port_end != null && var.frontend_port == null) 
 #   error_message = "You must provide either 'frontend_port' or both 'frontend_port_start' and 'frontend_port_end'."
 # }
}
variable "backend_port" {
  description = "The name of the LB"
  type        = string
  default     = null
}
variable "frontend_port_start" {
  description = "The name of the LB"
  type        = string
  default     = null
  #validation {
  #  condition = (var.frontend_port != null && var.frontend_port_start == null) 
  #  error_message = "You must provide either 'frontend_port' or both 'frontend_port_start' and 'frontend_port_end'."
  #}
}
variable "frontend_port_end" {
  description = "The name of the LB"
  type        = string
  default     = null
  #validation {
  #  condition = (var.frontend_port != null && var.frontend_port_end == null) 
  #  error_message = "You must provide either 'frontend_port' or both 'frontend_port_start' and 'frontend_port_end'."
  #}
}
variable "idle_timeout_in_minutes" {
  description = "The name of the LB"
  type        = string
  default     = null
}
variable "enable_floating_ip" {
  description = "The name of the LB"
  type        = string
  default     = null
}
variable "enable_tcp_reset" {
  description = "The name of the LB"
  type        = string
  default     = null
}
variable "backend_address_pool_id" {
  description = "The name of the LB"
  type        = string
  default     = null
}
*/