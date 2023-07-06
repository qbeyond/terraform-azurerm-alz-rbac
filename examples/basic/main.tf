provider "azurerm" {
}

data "azurerm_subscription" "current" {
}

locals {
  subscriptions_map = {
    "${data.azurerm_subscription.current.display_name}" = "${data.azurerm_subscription.current.subscription_id}"
    "<displayName>"                                     = "<subscription_id>"
  }
  managements_map = {
    "New"           = "new"
    "<displayName>" = "<id>"
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
}
