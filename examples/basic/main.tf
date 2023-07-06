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
  managements_map = {
    "Legacy" = "Legacy"
  }
}

module "alz_rbac" {
  source = "../../"

  subscriptions     = local.subscriptions_map
  management_groups = local.managements_map

  group_assignments = {
    "AMG_ALZ" = {
      pim_enabled = [true]
      "Owner"     = ["mg:ALZ"]
    }
  }

  pim_enabled_groups = [
    "AMG_Root_Owner"
  ]
}
