provider "azurerm" {
  skip_provider_registration = true
  features {

  }
}

data "azurerm_subscription" "current" {
}

locals {
  subscriptions_map = {
    "${data.azurerm_subscription.current.display_name}" = "${data.azurerm_subscription.current.subscription_id}"
  }

  subscriptions_rbac = merge([
    for k, v in local.subscriptions_map : {
      "SUB_${k}_OWNER"       = { "Owner" = ["sub:${v}"] }
      "SUB_${k}_CONTRIBUTOR" = { "Contributor" = ["sub:${v}"] }
      "SUB_${k}_READER"      = { "Reader" = ["sub:${v}"] }
  }]...)
}

module "alz_rbac" {
  source = "../../"

  group_assignments  = local.subscriptions_rbac
  pim_enabled_groups = ["SUB_${data.azurerm_subscription.current.display_name}_OWNER"]
}
