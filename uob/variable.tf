variable "vsphere_user" {
  description = "The vSphere user"
  type        = string
}

variable "VSPHERE_PASSWORD" {
  description = "The vSphere password"
  type        = string
}

variable "virtual_machines_linux_vmvmttsgv09_sg" {
  type = map(object({
    vsphere_cluster     = string
    vsphere_datastore   = string
    vsphere_network     = string
    vsphere_dc          = string
    vm_template         = string
    name          = string
    ipv4_address  = string
    ipv4_netmask  = string
    ipv4_gateway  = string
    dns_server    = string
    vm_domain    = string
    memory           = number
    logical_cpu   = number
    guest_id   = string
    os_disk_size  = number
    px_disk_size  = number
    vm_linked_clone  = bool
    serverpassword    = string
    OS    = string
    vsphere    = string
    vm            = string
    scsi_controller_count =string
    }))
}

# variable "virtual_machines_windows_vmvmttsgv09_sg" {
#   type = map(object({
#     vsphere_cluster     = string
#     vsphere_datastore   = string
#     vsphere_network     = string
#     vsphere_network1    = string
#     vsphere_dc          = string
#     vm_template         = string
#     name          = string
#     ipv4_address  = string
#     ipv4_netmask  = string
#     ipv4_address_bkp  = string
#     ipv4_netmask_bkp  = string
#     ipv4_gateway  = string
#     dns_server    = string
#     vm_domain    = string
#     memory           = number
#     logical_cpu   = number
#     scsi_type  = string
#     guest_id   = string
#     os_disk_size  = number
#     px_disk_size  = number
#     vm_linked_clone  = bool
#     serverpassword    = string
#     OS    = string
#     vsphere    = string
#     vm            = string
#     scsi_controller_count =string
#     }))
# }

/*
variable "virtual_machines_windows_vmvmttsgv04_tst" {
  type = map(object({
    vsphere_cluster     = string
    vsphere_datastore   = string
    vsphere_network     = string
    vsphere_network1    = string
    vsphere_dc          = string
    vm_template         = string
    name          = string
    ipv4_address  = string
    ipv4_netmask  = string
    ipv4_address_bkp  = string
    ipv4_netmask_bkp  = string
    ipv4_gateway  = string
    dns_server    = string
    vm_domain    = string
    memory           = number
    logical_cpu   = number
    scsi_type  = string
    guest_id   = string
    os_disk_size  = number
    px_disk_size  = number
    vm_linked_clone  = bool
    serverpassword    = string
    OS    = string
    vsphere    = string
    vm            = string
    scsi_controller_count =string
    }))
}
*/