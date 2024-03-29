# -------------------------------------------------------------
# File Name: variables.tf
# Defining simple variables required for VM deployment
#
# Tue Nov 3 12:59:12 BST 2020 - juliusn - initial script
# -------------------------------------------------------------

# -------------------------------------------------------------
# PROVIDER - VMware vSphere vCenter connection 
# -------------------------------------------------------------

variable "vsphere_server" {
    description = "vCenter server FQDN or IP"
    type        = string
  
}

variable "user" {
    description = "vSphere username to use to connect to the environment"
    type        = string

}

variable "password" {
    description = "vSphere password"
    type        = string
   
}


