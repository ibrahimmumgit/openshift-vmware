# AKS Cluster
resource "azurerm_kubernetes_cluster" "aks" {
  name                    = lower("${var.rg_prefix}${(local.effective_environment == "PROD") ? "-1${local.effective_applicationname}${local.next_aks_name}" : local.effective_environment == "UAT" ? "-4${local.effective_applicationname}${local.next_aks_name}" : "-5${local.effective_applicationname}${local.next_aks_name}"}")
  location                = var.location
  resource_group_name     = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
  kubernetes_version      = var.kubernetes_version
  azure_policy_enabled    = true
  sku_tier                = var.sku_tier  
  dns_prefix              = lower("${var.rg_prefix}${(local.effective_environment == "PROD") ? "-1${local.effective_applicationname}${local.next_aks_name}-dns" : local.effective_environment == "UAT" ? "-4${local.effective_applicationname}${local.next_aks_name}-dns" : "-5${local.effective_applicationname}${local.next_aks_name}-dns"}")
  #node_resource_group     = var.create_new_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
  node_os_upgrade_channel = "None"
  #automatic_upgrade_channel = "patch"
  network_profile {
    network_plugin = "kubenet"
    network_policy = "calico"
  }

  # Managed Identity
	  identity {
    type         = var.identity_access ? "SystemAssigned" : "UserAssigned"
    identity_ids = var.identity_access ? null : [var.create_new_identity_access && var.identity_name == null ?  azurerm_user_assigned_identity.uai[0].id : data.azurerm_user_assigned_identity.uai[0].id ]
  }

dynamic "azure_active_directory_role_based_access_control" {
  for_each = var.enable_rbac ? [1] : []
  content {
    tenant_id              = data.azurerm_client_config.current.tenant_id
    admin_group_object_ids = [data.azuread_group.group_rbac[0].object_id]
    azure_rbac_enabled     = true
  }

}


  dynamic "oms_agent" {
    for_each = var.enable_monitoring ? [1] : []
    content {
      log_analytics_workspace_id      = var.existing_log_analytics_workspace == null && var.create_new_application_insigts ? azurerm_log_analytics_workspace.alaw[0].id : data.azurerm_log_analytics_workspace.alaw[0].id
      msi_auth_for_monitoring_enabled = true
    }
  }


  # Node Pool Configuration
  default_node_pool {
    #name                 = lower("${var.rg_prefix}${(local.effective_environment == "PROD") ? "-1${local.effective_applicationname}${local.next_aksnode_name}" : local.effective_environment == "UAT" ? "-4${local.effective_applicationname}${local.next_aksnode_name}" : "-5${local.effective_applicationname}${local.next_aksnode_name}"}")
    name                        = var.node_pool_name #lower("${local.effective_applicationname}${local.next_aksnode_name}")
    #node_count                  = var.node_count
    vm_size                     = var.node_vm_size
    os_disk_size_gb             = 30
    os_sku                      = var.os_sku
    max_pods                    = 30
    type                        = "VirtualMachineScaleSets"
    auto_scaling_enabled        = true
    min_count                   = var.auto_scaler_profile_min_count
    max_count                   = var.auto_scaler_profile_max_count
    vnet_subnet_id              = data.azurerm_subnet.aks_subnet.id
    zones                       = var.zones == 1 ? ["1"] : var.zones == 2 ? ["1", "2"] : ["1", "2", "3"]
    #temporary_name_for_rotation = lower("${local.next_aksnode_name}tmp")
    

    node_labels = {
      "ApplicationName" = local.effective_applicationname
      "Environment"     = local.effective_environment
    }
   
  }

  # HTTP Application Routing
  http_application_routing_enabled = var.enable_http_application_routing

  # Linux Admin SSH Access
  # linux_profile {
  #   admin_username = var.linux_admin_username
  # #   ssh_key {
  # #     key_data = var.linux_ssh_public_key
  # #   }
  #  }


  tags = local.common_tags

  lifecycle {
    prevent_destroy = false
    ignore_changes = [
      name, dns_prefix, default_node_pool[0].temporary_name_for_rotation, default_node_pool[0].upgrade_settings
    ]
  }

}

