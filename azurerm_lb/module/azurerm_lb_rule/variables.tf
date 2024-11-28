variable "azlb_rule_name" {
  description = "The name of the LB"
  type        = string
  default     = null
}
variable "azlb_id" {
  description = "The name of the LB"
  type        = string
  default     = null
}
variable "frontend_ip_configuration_name" {
  description = "The name of the LB"
  type        = string
  default     = null
}
variable "azlb_rule_protocol" {
  description = "The name of the LB"
  type        = string
  default     = null
}
variable "azlb_rule_frontend_port" {
  description = "The name of the LB"
  type        = string
  default     = null
}
variable "azlb_rule_backend_port" {
  description = "The name of the LB"
  type        = string
  default     = null
}
variable "backend_address_pool_ids" {
  description = "The name of the LB"
  type        = list
  default     = null
}
variable "probe_id" {
  description = "The name of the LB"
  type        = string
  default     = null
}
variable "enable_floating_ip" {
  description = "The name of the LB"
  type        = string
  default     = null
}
variable "idle_timeout_in_minutes" {
  description = "The name of the LB"
  type        = string
  default     = null
}
variable "load_distribution" {
  description = "The name of the LB"
  type        = string
  default     = null
}
variable "disable_outbound_snat" {
  description = "The name of the LB"
  type        = string
  default     = null
}
variable "enable_tcp_reset" {
  description = "The name of the LB"
  type        = string
  default     = null
}
