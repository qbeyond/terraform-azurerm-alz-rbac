output "aad_groups" {
  value       = merge(azuread_group.subscription_owners, azuread_group.subscription_contributors, azuread_group.subscription_readers, azuread_group.management_owners, azuread_group.management_contributors, azuread_group.management_readers, azuread_group.custom_groups)
  description = "All AAD Groups that have been created."
}
