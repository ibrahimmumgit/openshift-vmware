provider "vsphere" {
    alias          = "vmvmttsgv09_sg"
    user           = var.vsphere_user
    password       = var.VSPHERE_PASSWORD
    vsphere_server = "192.168.8.20"
    allow_unverified_ssl = true
}

provider "vsphere" {
    alias          = "vmvmttsgv04_tst"
    user           = var.vsphere_user
    password       = var.VSPHERE_PASSWORD
    vsphere_server = "192.168.9.70"
    allow_unverified_ssl = true
}