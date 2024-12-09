variable "is_public" {
  description = "The name of the LB"
  type        = bool
  default     = null
}
/*
variable "frontend_ip_configuration" {
  description = "The name of the LB"
  type = map(object({
    name                          = string
    subnet_id                     = string
    private_ip_address_allocation = string
    private_ip_address_version    = string
    public_ip_address_id          = string
  }))
  default = {
    "name" = null
    subnet_id                     = null
    private_ip_address_allocation = null
    private_ip_address_version    = null
    public_ip_address_id          = null  
    }
}
*/
###########  frontend_ip_configuration Variables ##############
variable "frontend_count" {
  description = "Number of frontend IP configurations"
  type        = number
  default     = null
}
variable "frontend_name1" {
  description = "Name of the first frontend configuration"
  type        = string
  default     = null
}
variable "subnet_id1" {
  description = "Subnet ID for the first frontend configuration"
  type        = string
  default     = null
}
variable "private_ip_address_allocation1" {
  description = "Private IP address allocation for the first configuration"
  type        = string
  default     = "Dynamic"
}
variable "private_ip_address_version1" {
  description = "Private IP address version for the first configuration"
  type        = string
  default     = "IPv4"
}
variable "public_ip_address_id1" {
  description = "Public IP address ID for the first configuration"
  type        = string
  default     = null
}
variable "frontend_name2" {
  description = "Name of the first frontend configuration"
  type        = string
  default     = null
}
variable "subnet_id2" {
  description = "Subnet ID for the first frontend configuration"
  type        = string
  default     = null
}
variable "private_ip_address_allocation2" {
  description = "Private IP address allocation for the first configuration"
  type        = string
  default     = "Dynamic"
}
variable "private_ip_address_version2" {
  description = "Private IP address version for the first configuration"
  type        = string
  default     = "IPv4"
}
variable "public_ip_address_id2" {
  description = "Public IP address ID for the first configuration"
  type        = string
  default     = null
}
################################
variable "azlb_name" {
  description = "The name of the LB"
  type        = string
  default     = null
}
variable "azlb_rg_name" {
  description = "The name of the LB"
  type        = string
  default     = null
}
variable "zlb_location_name" {
  description = "The name of the LB"
  type        = string
  default     = null
}
variable "edge_zone" {
  description = "The name of the LB"
  type        = string
  default     = null
}
variable "lb_sku" {
  description = "The name of the LB"
  type        = string
  default     = null
}
variable "lb_sku_tier" {
  description = "The name of the LB"
  type        = string
  default     = null
}
variable "tags" {
  description = "The name of the LB"
  type        = map(string)
  default     = {}
}
variable "azlb_pub_ip_id" {
  description = "The name of the LB"
  type        = string
  default     = null
}
variable "frontend_subnet_name" {
  description = "The name of the LB"
  type        = string
  default     = null
}
variable "frontend_subnet_id" {
  description = "The name of the LB"
  type        = string
  default     = null
}
variable "frontend_private_ip_address_allocation" {
  description = "The name of the LB"
  type        = string
  default     = null
}
variable "frontend_private_ip_address_version" {
  description = "The name of the LB"
  type        = string
  default     = null
}