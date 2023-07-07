provider "azurerm" {
  //skip_provider_registration = true #this is only
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
    "new" = {
      display_name = "New"
    }
  }
}

module "alz_rbac" {
  source = "../../"

  subscriptions     = local.subscriptions_map
  management_groups = local.managements_map

  custom_groups = {
    "AMG_ALZ_OWNER" = {
      pim_enabled = true
      role_assignments = {
        "Owner" = ["mg:alz"]
      }
    }
  }
}
