module "linux_vm" {
  source = "./modules/linux"  
  vsphere_user       = var.vsphere_user
  VSPHERE_PASSWORD   = var.VSPHERE_PASSWORD
  virtual_machines_linux_vmvmttsgv09_sg  =   var.virtual_machines_linux_vmvmttsgv09_sg
}

