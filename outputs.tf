output "subscription_ad_groups" {
  value       = azuread_group.subscription_owners
  description = "All AAD Groups that have been created"
}
