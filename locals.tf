locals {
  group_role_assignments = merge(flatten([
    for group, assignments in var.custom_groups : [
      for role, scopes in assignments.role_assignments : role != "pim_enabled" ? {
        for scope in scopes : "${group}_${role}_${scope}" => {
          scope = coalesce(
            scope == "root" ? format("/providers/Microsoft.Management/managementGroups/%s", data.azurerm_client_config.current.tenant_id) : null,
            can(regex("^mg:.*$", scope)) ? format("/providers/Microsoft.Management/managementGroups/%s", trimprefix(scope, "mg:")) : null,
            can(regex("^sub:.*$", scope)) ? format("/subscriptions/%s", trimprefix(scope, "sub:")) : null,
            scope
          )
          role_definition_name = can(regex("((\\w|\\d){8}-((\\w|\\d){4}-){3}(\\w|\\d){12}$)", role)) ? null : role
          role_definition_id   = can(regex("((\\w|\\d){8}-((\\w|\\d){4}-){3}(\\w|\\d){12}$)", role)) ? format("/providers/Microsoft.Authorization/roleDefinitions/%s", basename(role)) : null
          principal            = group
  } } : {}]])...)

  pim_targets = merge(
    { for k in keys(var.subscriptions)      : "sub_${k}" => { group_id = azuread_group.subscription_owners[k].object_id } },
    { for k in keys(var.management_groups)  : "mg_${k}"  => { group_id = azuread_group.management_owners[k].object_id } },
    { for k, v in var.custom_groups : k => { group_id = azuread_group.custom_groups[k].object_id } if try(v.pim_enabled, false) }
  )
}
