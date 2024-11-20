# create a linux vm for vmvmttsgv09_sg vsphere server

resource "vsphere_virtual_machine" "windows_vm_vmvmttsgv09_sg" {
 
  for_each = { for k, v in var.virtual_machines_windows_vmvmttsgv09_sg : k => v if lower(v.OS) == "windows" && v.vsphere == "vmvmttsgv09_sg" }

    provider   = vsphere.vmvmttsgv09_sg
    name       = each.value.name
    memory     = each.value.memory
    num_cpus   = each.value.logical_cpu
    cpu_hot_add_enabled    = true
    memory_hot_add_enabled = true
    extra_config_reboot_required = false
    scsi_type = each.value.scsi_type
    guest_id   = each.value.guest_id
    scsi_controller_count  = each.value.scsi_controller_count

  resource_pool_id = data.vsphere_compute_cluster.cluster_vmvmttsgv09_sg[each.key].resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore_vmvmttsgv09_sg[each.key].id

  network_interface {
      network_id   = data.vsphere_network.network_vmvmttsgv09_sg[each.key].id
    }

    disk {
        unit_number      = 0
        label            = "OS"
        size             = each.value.os_disk_size
        eagerly_scrub    = data.vsphere_virtual_machine.template_vmvmttsgv09_sg[each.key].disks.0.eagerly_scrub
        thin_provisioned = data.vsphere_virtual_machine.template_vmvmttsgv09_sg[each.key].disks.0.thin_provisioned
    }


    dynamic "disk" {
      for_each = each.value.vm == "app" ? [1] : []
        content {
        unit_number      = 1
        label            = "APP"
        size             = 20
        eagerly_scrub    = data.vsphere_virtual_machine.template_vmvmttsgv09_sg[each.key].disks.0.eagerly_scrub
        thin_provisioned = data.vsphere_virtual_machine.template_vmvmttsgv09_sg[each.key].disks.0.thin_provisioned
      }
    }

    dynamic "disk" {
      for_each = each.value.vm == "db" ? [1] : []
        content {
        unit_number      = 1
        label            = "poracle"
        size             = 20
        eagerly_scrub    = data.vsphere_virtual_machine.template_vmvmttsgv09_sg[each.key].disks.0.eagerly_scrub
        thin_provisioned = data.vsphere_virtual_machine.template_vmvmttsgv09_sg[each.key].disks.0.thin_provisioned
      }
    }

    dynamic "disk" {
      for_each = each.value.vm == "db" ? [1] : []
        content {
        unit_number      = 15
        label            = "poradata1"
        size             = 5
        eagerly_scrub    = data.vsphere_virtual_machine.template_vmvmttsgv09_sg[each.key].disks.0.eagerly_scrub
        thin_provisioned = data.vsphere_virtual_machine.template_vmvmttsgv09_sg[each.key].disks.0.thin_provisioned
      }
    }  

    dynamic "disk" {
      for_each = each.value.vm == "db" ? [1] : []
        content {
        unit_number      = 30
        label            = "poradata2"
        size             = 5
        eagerly_scrub    = data.vsphere_virtual_machine.template_vmvmttsgv09_sg[each.key].disks.0.eagerly_scrub
        thin_provisioned = data.vsphere_virtual_machine.template_vmvmttsgv09_sg[each.key].disks.0.thin_provisioned
      }
    }   

    dynamic "disk" {
      for_each = each.value.vm == "db" ? [1] : []
        content {
        unit_number      = 45
        label            = "poradata3"
        size             = 5
        eagerly_scrub    = data.vsphere_virtual_machine.template_vmvmttsgv09_sg[each.key].disks.0.eagerly_scrub
        thin_provisioned = data.vsphere_virtual_machine.template_vmvmttsgv09_sg[each.key].disks.0.thin_provisioned
      }
    } 

    dynamic "disk" {
      for_each = each.value.vm == "db" ? [1] : []
        content {
        unit_number      = 31
        label            = "poraarch1"
        size             = 5
        eagerly_scrub    = data.vsphere_virtual_machine.template_vmvmttsgv09_sg[each.key].disks.0.eagerly_scrub
        thin_provisioned = data.vsphere_virtual_machine.template_vmvmttsgv09_sg[each.key].disks.0.thin_provisioned
      }
    }

    dynamic "disk" {
      for_each = each.value.vm == "db" ? [1] : []
        content {
        unit_number      = 46
        label            = "poraarch2"
        size             = 5
        eagerly_scrub    = data.vsphere_virtual_machine.template_vmvmttsgv09_sg[each.key].disks.0.eagerly_scrub
        thin_provisioned = data.vsphere_virtual_machine.template_vmvmttsgv09_sg[each.key].disks.0.thin_provisioned
      }
    }

    dynamic "disk" {
      for_each = each.value.vm == "db" ? [1] : []
        content {
        unit_number      = 2
        label            = "porabkup"
        size             = 5
        eagerly_scrub    = data.vsphere_virtual_machine.template_vmvmttsgv09_sg[each.key].disks.0.eagerly_scrub
        thin_provisioned = data.vsphere_virtual_machine.template_vmvmttsgv09_sg[each.key].disks.0.thin_provisioned
      }
    }

    dynamic "disk" {
      for_each = each.value.vm == "db" ? [1] : []
        content {
        unit_number      = 3
        label            = "restore filesystem"
        size             = 5
        eagerly_scrub    = data.vsphere_virtual_machine.template_vmvmttsgv09_sg[each.key].disks.0.eagerly_scrub
        thin_provisioned = data.vsphere_virtual_machine.template_vmvmttsgv09_sg[each.key].disks.0.thin_provisioned
      }
    }

    clone {
      template_uuid = data.vsphere_virtual_machine.template_vmvmttsgv09_sg[each.key].id

      customize {
        timeout = "20"

        windows_options {
          computer_name = each.value.name
          workgroup    = each.value.vm_domain
          admin_password = "Pass123"
        }

        network_interface {
          ipv4_address = each.value.ipv4_address 
          ipv4_netmask = each.value.ipv4_netmask 
        }

        ipv4_gateway    = each.value.ipv4_gateway 
        dns_server_list = [ each.value.dns_server ]
      }
    } 
  
  connection {
      host     = each.value.ipv4_address
      type     = "winrm"
      user     = "Administrator"
      password = "${each.value.serverpassword}"
      insecure = true
      use_ntlm = true
    }
}

/*

# create a linux vm for vmvmttsgv04_tst vsphere server

resource "vsphere_virtual_machine" "windows_vm_vmvmttsgv04_tst" {

  for_each = { for k, v in var.virtual_machines_windows_vmvmttsgv04_tst : k => v if lower(v.OS) == "windows" && v.vsphere == "vmvmttsgv04_tst" }

    provider   = vsphere.vmvmttsgv04_tst
    name       = each.value.name
    memory     = each.value.memory
    num_cpus   = each.value.logical_cpu
    cpu_hot_add_enabled    = true
    memory_hot_add_enabled = true
    extra_config_reboot_required = false
    scsi_type = each.value.scsi_type
    guest_id   = each.value.guest_id
    scsi_controller_count  = each.value.scsi_controller_count

  resource_pool_id = data.vsphere_compute_cluster.cluster_vmvmttsgv04_tst[each.key].resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore_vmvmttsgv04_tst[each.key].id

  network_interface {
      network_id   = data.vsphere_network.network_vmvmttsgv04_tst[each.key].id
    }

    disk {
        unit_number      = 0
        label            = "OS"
        size             = each.value.os_disk_size
        eagerly_scrub    = data.vsphere_virtual_machine.template_vmvmttsgv04_tst[each.key].disks.0.eagerly_scrub
        thin_provisioned = data.vsphere_virtual_machine.template_vmvmttsgv04_tst[each.key].disks.0.thin_provisioned
    } 

    dynamic "disk" {
      for_each = each.value.vm == "app" ? [1] : []
        content {
        unit_number      = 1
        label            = "APP"
        size             = 20
        eagerly_scrub    = data.vsphere_virtual_machine.template_vmvmttsgv04_tst[each.key].disks.0.eagerly_scrub
        thin_provisioned = data.vsphere_virtual_machine.template_vmvmttsgv04_tst[each.key].disks.0.thin_provisioned
      }
    }

    dynamic "disk" {
      for_each = each.value.vm == "db" ? [1] : []
        content {
        unit_number      = 1
        label            = "poracle"
        size             = 20
        eagerly_scrub    = data.vsphere_virtual_machine.template_vmvmttsgv04_tst[each.key].disks.0.eagerly_scrub
        thin_provisioned = data.vsphere_virtual_machine.template_vmvmttsgv04_tst[each.key].disks.0.thin_provisioned
      }
    }

    dynamic "disk" {
      for_each = each.value.vm == "db" ? [1] : []
        content {
        unit_number      = 15
        label            = "poradata1"
        size             = 5
        eagerly_scrub    = data.vsphere_virtual_machine.template_vmvmttsgv04_tst[each.key].disks.0.eagerly_scrub
        thin_provisioned = data.vsphere_virtual_machine.template_vmvmttsgv04_tst[each.key].disks.0.thin_provisioned
      }
    }  

    dynamic "disk" {
      for_each = each.value.vm == "db" ? [1] : []
        content {
        unit_number      = 30
        label            = "poradata2"
        size             = 5
        eagerly_scrub    = data.vsphere_virtual_machine.template_vmvmttsgv04_tst[each.key].disks.0.eagerly_scrub
        thin_provisioned = data.vsphere_virtual_machine.template_vmvmttsgv04_tst[each.key].disks.0.thin_provisioned
      }
    }   

    dynamic "disk" {
      for_each = each.value.vm == "db" ? [1] : []
        content {
        unit_number      = 45
        label            = "poradata3"
        size             = 5
        eagerly_scrub    = data.vsphere_virtual_machine.template_vmvmttsgv04_tst[each.key].disks.0.eagerly_scrub
        thin_provisioned = data.vsphere_virtual_machine.template_vmvmttsgv04_tst[each.key].disks.0.thin_provisioned
      }
    } 

    dynamic "disk" {
      for_each = each.value.vm == "db" ? [1] : []
        content {
        unit_number      = 31
        label            = "poraarch1"
        size             = 5
        eagerly_scrub    = data.vsphere_virtual_machine.template_vmvmttsgv04_tst[each.key].disks.0.eagerly_scrub
        thin_provisioned = data.vsphere_virtual_machine.template_vmvmttsgv04_tst[each.key].disks.0.thin_provisioned
      }
    }

    dynamic "disk" {
      for_each = each.value.vm == "db" ? [1] : []
        content {
        unit_number      = 46
        label            = "poraarch2"
        size             = 5
        eagerly_scrub    = data.vsphere_virtual_machine.template_vmvmttsgv04_tst[each.key].disks.0.eagerly_scrub
        thin_provisioned = data.vsphere_virtual_machine.template_vmvmttsgv04_tst[each.key].disks.0.thin_provisioned
      }
    }

    dynamic "disk" {
      for_each = each.value.vm == "db" ? [1] : []
        content {
        unit_number      = 2
        label            = "porabkup"
        size             = 5
        eagerly_scrub    = data.vsphere_virtual_machine.template_vmvmttsgv04_tst[each.key].disks.0.eagerly_scrub
        thin_provisioned = data.vsphere_virtual_machine.template_vmvmttsgv04_tst[each.key].disks.0.thin_provisioned
      }
    }

    dynamic "disk" {
      for_each = each.value.vm == "db" ? [1] : []
        content {
        unit_number      = 3
        label            = "restore filesystem"
        size             = 5
        eagerly_scrub    = data.vsphere_virtual_machine.template_vmvmttsgv04_tst[each.key].disks.0.eagerly_scrub
        thin_provisioned = data.vsphere_virtual_machine.template_vmvmttsgv04_tst[each.key].disks.0.thin_provisioned
      }
    } 

    clone {
      template_uuid = data.vsphere_virtual_machine.template_vmvmttsgv04_tst[each.key].id

      customize {
        timeout = "20"

        windows_options {
          computer_name = each.value.name
          workgroup    = each.value.vm_domain
          admin_password = "Pass123"
        }

        network_interface {
          ipv4_address = each.value.ipv4_address 
          ipv4_netmask = each.value.ipv4_netmask 
        }

        ipv4_gateway    = each.value.ipv4_gateway 
        dns_server_list = [ each.value.dns_server ]
      }
    } 
  
  connection {
      host     = each.value.ipv4_address
      type     = "winrm"
      user     = "Administrator"
      password = "${each.value.serverpassword}"
      insecure = true
      use_ntlm = true
    }
}

*/