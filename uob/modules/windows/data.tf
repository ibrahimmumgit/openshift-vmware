# data.tf

#vmvmttsgv09_sg

data "vsphere_datacenter" "dc_vmvmttsgv09_sg" {
  for_each = var.virtual_machines_windows_vmvmttsgv09_sg
  provider = vsphere.vmvmttsgv09_sg

  name = each.value.vsphere_dc
}

data "vsphere_compute_cluster" "cluster_vmvmttsgv09_sg" {
  for_each = var.virtual_machines_windows_vmvmttsgv09_sg
  provider = vsphere.vmvmttsgv09_sg

  name          = each.value.vsphere_cluster
  datacenter_id = data.vsphere_datacenter.dc_vmvmttsgv09_sg[each.key].id
}

data "vsphere_datastore" "datastore_vmvmttsgv09_sg" {
  for_each = var.virtual_machines_windows_vmvmttsgv09_sg
  provider = vsphere.vmvmttsgv09_sg

  name          = each.value.vsphere_datastore
  datacenter_id = data.vsphere_datacenter.dc_vmvmttsgv09_sg[each.key].id
}

data "vsphere_network" "network_vmvmttsgv09_sg" {
  for_each = var.virtual_machines_windows_vmvmttsgv09_sg
  provider = vsphere.vmvmttsgv09_sg

  name          = each.value.vsphere_network
  datacenter_id = data.vsphere_datacenter.dc_vmvmttsgv09_sg[each.key].id
}

data "vsphere_network" "network1_vmvmttsgv09_sg" {
  for_each = var.virtual_machines_windows_vmvmttsgv09_sg
  provider = vsphere.vmvmttsgv09_sg

  name          = each.value.vsphere_network1
  datacenter_id = data.vsphere_datacenter.dc_vmvmttsgv09_sg[each.key].id
}


data "vsphere_virtual_machine" "template_vmvmttsgv09_sg" {
  for_each = var.virtual_machines_windows_vmvmttsgv09_sg
  provider = vsphere.vmvmttsgv09_sg

  name          = each.value.vm_template
  datacenter_id = data.vsphere_datacenter.dc_vmvmttsgv09_sg[each.key].id
}
/*
# vsphere_vmvmttsgv04_tst

data "vsphere_datacenter" "dc_vmvmttsgv04_tst" {
  for_each = var.virtual_machines_windows_vmvmttsgv04_tst
  provider = vsphere.vmvmttsgv04_tst

  name = each.value.vsphere_dc
}

data "vsphere_compute_cluster" "cluster_vmvmttsgv04_tst" {
  for_each = var.virtual_machines_windows_vmvmttsgv04_tst
  provider = vsphere.vmvmttsgv04_tst

  name          = each.value.vsphere_cluster
  datacenter_id = data.vsphere_datacenter.dc_vmvmttsgv04_tst[each.key].id
}

data "vsphere_datastore" "datastore_vmvmttsgv04_tst" {
  for_each = var.virtual_machines_windows_vmvmttsgv04_tst
  provider = vsphere.vmvmttsgv04_tst

  name          = each.value.vsphere_datastore
  datacenter_id = data.vsphere_datacenter.dc_vmvmttsgv04_tst[each.key].id
}

data "vsphere_network" "network_vmvmttsgv04_tst" {
  for_each = var.virtual_machines_windows_vmvmttsgv04_tst
  provider = vsphere.vmvmttsgv04_tst

  name          = each.value.vsphere_network
  datacenter_id = data.vsphere_datacenter.dc_vmvmttsgv04_tst[each.key].id
}

data "vsphere_network" "network1_vmvmttsgv04_tst" {
  for_each = var.virtual_machines_windows_vmvmttsgv04_tst
  provider = vsphere.vmvmttsgv04_tst

  name          = each.value.vsphere_network1
  datacenter_id = data.vsphere_datacenter.dc_vmvmttsgv04_tst[each.key].id
}

data "vsphere_virtual_machine" "template_vmvmttsgv04_tst" {
  for_each = var.virtual_machines_windows_vmvmttsgv04_tst
  provider = vsphere.vmvmttsgv04_tst

  name          = each.value.vm_template
  datacenter_id = data.vsphere_datacenter.dc_vmvmttsgv04_tst[each.key].id
}
*/