module "alb" {
  source = "../alb"
  alb_name          = var.alb_name
  is_internal       = var.is_internal
  lb_type           = var.lb_type
  sg_id             = var.sg_id
  subnet_ids        = var.subnet_ids
  delete_protection = var.delete_protection
  idle_timeout      = var.idle_timeout
  tags              = merge({ Name = var.alb_name }, var.tags)
  app_prefix = "test"
}
 
# Create Target Groups
module "target_groups" {
  source = "../target-group"
 
  for_each = var.target_groups != null ? { for idx, tg in var.target_groups : idx => tg } : {}
 
  name              = each.value.name
  port              = each.value.port
  protocol          = each.value.protocol
  target_type       = each.value.target_type
  vpc_id            = var.vpc_id
  health_check      = each.value.health_check
  tags              = each.value.tags
  target_id         = each.value.target_id
  availability_zone = each.value.availability_zone
}
 
# Collect Target Group ARNs
locals {
  target_group_arns = { for idx, tg in module.target_groups : idx => tg.target_group_arn }
}
 
# Create Listeners
module "listeners" {
  source = "../listener"
 
  for_each = var.listeners != null ? { for idx, listener in var.listeners : idx => listener } : {}
 
  module_enabled               = true
  load_balancer_arn            = module.alb.arn
  port                         = each.value.port
  protocol                     = each.value.protocol
  alpn_policy                  = lookup(each.value, "alpn_policy", null)
  ssl_policy                   = lookup(each.value, "ssl_policy", null)
  certificate_arn              = lookup(each.value, "certificate_arn", null)
  default_action               = each.value.default_action
  module_tags                  = lookup(each.value, "module_tags", {})
  tags                         = lookup(each.value, "tags", {})
  module_depends_on            = lookup(each.value, "module_depends_on", [])
  additional_certificates_arns = lookup(each.value, "additional_certificates_arns", [])
}
 
# Collect Listener ARNs
locals {
  listener_arns = { for idx, listener in module.listeners : idx => listener.listener_arn }
}
 
# Prepare Listener Rules
locals {
  listener_rules = var.listeners != null ? flatten([
    for listener_idx, listener in var.listeners : [
      for rule in lookup(listener, "rules", []) : merge(rule, {
        listener_index = listener_idx
      })
    ]
  ]) : []
}
 
locals {
  processed_listener_rules = [
    for rule in local.listener_rules : merge(rule, {
      action = rule.action.type == "forward" && contains(keys(rule.action), "target_group_index") ? merge(rule.action, {
        target_group_arn = local.target_group_arns[tostring(rule.action.target_group_index)]
      }) : rule.action
    })
  ]
}
 
module "listener_rules" {
  source = "../listener-rule"
 
  for_each = { for idx, rule in local.processed_listener_rules : idx => rule }
 
  module_enabled    = true
  listener_arn      = local.listener_arns[tostring(each.value.listener_index)]
  priority          = each.value.priority
  action            = each.value.action
  conditions        = each.value.conditions
  module_tags       = lookup(each.value, "module_tags", {})
  tags              = lookup(each.value, "tags", {})
  module_depends_on = lookup(each.value, "module_depends_on", [])
}
 

