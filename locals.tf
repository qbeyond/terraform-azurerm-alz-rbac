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
        }
      } : {}
    ]
  ])...)

  pim_targets_owner = merge(
    // Iterate over all subscription keys from var.subscriptions
    // For each subscription key create a map entry with key format
    // Value: An object containing the group_id from the corresponding subscription_owners Azure AD group's object_id
    { for k in keys(var.subscriptions)     : "sub_${k}" => { group_id = azuread_group.subscription_owners[k].object_id } },
    
    // Second for loop: Iterate over all management group keys from var.management_groups
    // For each management group key create a map entry with key format
    // Value: An object containing the group_id from the corresponding management_owners Azure AD group's object_id
    { for k in keys(var.management_groups) : "mg_${k}"  => { group_id = azuread_group.management_owners[k].object_id } }
  )
  // merge(): Combines both map outputs into a single pim_targets_owner map
  // Example result: { "sub_production" = { group_id = "uuid-1" }, "mg_root" = { group_id = "uuid-2" } }

  pim_targets_contributor = merge(
    // Create entries with key format
    // The "if can(...)" condition checks if the azuread_group.subscription_contributors[k] resource exists
    // If the group doesn't exist, this entry is skipped (prevents errors for missing resources)
    { for k in keys(var.subscriptions) : "sub_${k}_contributor" => { group_id = azuread_group.subscription_contributors[k].object_id } if can(azuread_group.subscription_contributors[k])},
    
    // Create entries with key format
    // The "if can(...)" condition skips entries where the contributor group doesn't exist
    { for k in keys(var.management_groups) : "mg_${k}_contributor" => { group_id = azuread_group.management_contributors[k].object_id } if can(azuread_group.management_contributors[k])}
  )
  // Result: A map of all contributor groups that actually exist, across subscriptions and management groups

  pim_targets_custom_groups = {
    for k, v in var.custom_groups : k => { group_id = azuread_group.custom_groups[k].object_id } 
    if try(v.azuread_role_assignable, false) && try(v.pim_settings, null) != null
  }
  // Only includes custom groups that are:
  // 1. Marked as azuread_role_assignable = true
  // 2. Have pim_settings defined

  pim_targets = merge(
    // Combines all three maps into a single unified map containing:
    // - All subscription and management group owner groups
    // - All existing contributor groups
    // - All custom groups marked as role-assignable
    local.pim_targets_owner,
    local.pim_targets_contributor,
    local.pim_targets_custom_groups
  )
}
