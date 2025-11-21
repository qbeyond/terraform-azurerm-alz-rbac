# Module
[![GitHub tag](https://img.shields.io/github/tag/qbeyond/terraform-azurerm-alz-rbac.svg)](https://registry.terraform.io/modules/qbeyond/alz-rbac/azurerm/latest)
[![License](https://img.shields.io/github/license/qbeyond/terraform-azurerm-alz-rbac.svg)](https://github.com/qbeyond/terraform-azurerm-alz-rbac/blob/main/LICENSE)
----

This terraform module creates Azure AD groups and role assignments for management groups and subscriptions. It is specifically designed to work in the governance module that is created by the prerequisites oneshot deployment.

The module is designed to create default groups (Owner, Contributor, and Reader) and assignments for the specified subscriptions and management groups. The module automatically generates the name of the group by prefixing it with `SUB_` for subscriptions and `AMG_` for management groups and adds the role as a suffix.

The Contributor and Owner groups created for subscriptions and management groups are automatically enabled for Privileged Identity Management (PIM)

The `custom_assignments` input variable allows you to define custom groups and assignments, including the ability to enable Privileged Identity Management (PIM) for the groups.

TODO: there is currently no stage variable so this module will run into errors when you have no AAD premium license.

**Important**: The `management_groups` variable reuses the structure of the `custom_landing_zone` variable from the [CAF module](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BExamples%5D-Deploy-Custom-Landing-Zone-Archetypes)

<!-- BEGIN_TF_DOCS -->
## Usage

```hcl
provider "azurerm" {
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
      azuread_role_assignable = true
      role_assignments = {
        "Owner" = ["mg:alz"]
      }
    }
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | >= 3.0.2 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.108.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_custom_groups"></a> [custom\_groups](#input\_custom\_groups) | <pre>"<group_name>" = {<br/>  azuread_role_assignable = optional(bool)<br/>  role_assignments = {<br/>    "<role_assignment>" = ["<scope>"]<br/>  }<br/>  pim_settings = optional({...})  (individual PIM settings for this group)<br/>}</pre> | <pre>map(object({<br/>    security_enabled        = optional(bool, true)<br/>    azuread_role_assignable = optional(bool)<br/>    role_assignments        = map(list(string))<br/>    pim_settings            = optional(object({<br/>      max_duration          = optional(string, "PT10H")<br/>      require_justification = optional(bool, true)<br/>      require_approval      = optional(bool, false)<br/>      approver_group_id     = optional(string)<br/>    }))<br/>  }))</pre> | `{}` | no |
| <a name="input_groups_config"></a> [groups\_config](#input\_groups\_config) | Optional config for AAD groups by scope and role | <pre>object({<br/>    subscriptions = optional(object({<br/>      owner = optional(object({<br/>        security_enabled   = optional(bool, true)<br/>        assignable_to_role = optional(bool, false)<br/>      }))<br/>      contributor = optional(object({<br/>        security_enabled   = optional(bool, true)<br/>        assignable_to_role = optional(bool, false)<br/>      }))<br/>      reader = optional(object({<br/>        security_enabled   = optional(bool, true)<br/>        assignable_to_role = optional(bool, false)<br/>      }))<br/>    }))<br/>    management_groups = optional(object({<br/>      owner = optional(object({<br/>        security_enabled   = optional(bool, true)<br/>        assignable_to_role = optional(bool, false)<br/>      }))<br/>      contributor = optional(object({<br/>        security_enabled   = optional(bool, true)<br/>        assignable_to_role = optional(bool, false)<br/>      }))<br/>      reader = optional(object({<br/>        security_enabled   = optional(bool, true)<br/>        assignable_to_role = optional(bool, false)<br/>      }))<br/>    }))<br/>  })</pre> | `{}` | no |
| <a name="input_management_groups"></a> [management\_groups](#input\_management\_groups) | <pre>"<management_group_id>" = {                 (this variable is reusing the structure of the management groups for custom_landing_zones from the caf module )<br/>    displayName = "<management_group_name>"<br/>  }</pre> | <pre>map(object({<br/>    display_name = string<br/>  }))</pre> | `{}` | no |
| <a name="input_pim_settings"></a> [pim\_settings](#input\_pim\_settings) | PIM settings configuration for Owner and Contributor roles | <pre>object({<br/>    owner = optional(object({<br/>      max_duration          = optional(string, "PT10H")<br/>      require_justification = optional(bool, true)<br/>      require_approval      = optional(bool, false)<br/>      approver_group_id     = optional(string)<br/>    }))<br/>    contributor = optional(object({<br/>      max_duration          = optional(string, "PT10H")<br/>      require_justification = optional(bool, true)<br/>      require_approval      = optional(bool, false)<br/>      approver_group_id     = optional(string)<br/>    }))<br/>  })</pre> | `{}` | no |
| <a name="input_subscriptions"></a> [subscriptions](#input\_subscriptions) | Mapping of subscription names to subscription IDs. | `map(string)` | `{}` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aad_groups"></a> [aad\_groups](#output\_aad\_groups) | All AAD Groups that have been created. |

      ## Resource types

      | Type | Used |
      |------|-------|
        | [azuread_group](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group) | 7 |
        | [azuread_group_role_management_policy](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group_role_management_policy) | 3 |
        | [azurerm_role_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | 7 |

      **`Used` only includes resource blocks.** `for_each` and `count` meta arguments, as well as resource blocks of modules are not considered.
    
## Modules

No modules.

        ## Resources by Files

            ### main.tf

            | Name | Type |
            |------|------|
                  | [azuread_group.custom_groups](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group) | resource |
                  | [azuread_group.management_contributors](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group) | resource |
                  | [azuread_group.management_owners](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group) | resource |
                  | [azuread_group.management_readers](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group) | resource |
                  | [azuread_group.subscription_contributors](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group) | resource |
                  | [azuread_group.subscription_owners](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group) | resource |
                  | [azuread_group.subscription_readers](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group) | resource |
                  | [azuread_group_role_management_policy.pim_contributor](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group_role_management_policy) | resource |
                  | [azuread_group_role_management_policy.pim_custom_groups](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group_role_management_policy) | resource |
                  | [azuread_group_role_management_policy.pim_owner](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group_role_management_policy) | resource |
                  | [azurerm_role_assignment.custom_groups](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
                  | [azurerm_role_assignment.management_contributors](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
                  | [azurerm_role_assignment.management_owners](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
                  | [azurerm_role_assignment.management_readers](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
                  | [azurerm_role_assignment.subscription_contributors](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
                  | [azurerm_role_assignment.subscription_owners](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
                  | [azurerm_role_assignment.subscription_readers](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
                  | [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
    
<!-- END_TF_DOCS -->

## Contribute

Please use Pull requests to contribute.

When a new Feature or Fix is ready to be released, create a new Github release and adhere to [Semantic Versioning 2.0.0](https://semver.org/lang/de/spec/v2.0.0.html).