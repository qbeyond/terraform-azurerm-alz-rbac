# Module

----

This terraform module creates Azure Ad groups and role assignments for management groups and subscriptions. It is specifically designed to work in the governance module that is created by the Prerequisites oneshot deployment module

The module is designed to create default groups (Owner, Contributor, and Reader) and assignments for the specified subscriptions and management groups. The module automatically generates the name of the group by prefixing it with `SUB_` for subscriptions and `AMG_` for management groups and adds the role as a suffix.

The Reader and Owner groups created for subscriptions and management groups are automatically enabled for Privileged Identity Management (PIM)

The `custom_assignments` input variable allows you to define custom group assignments, including the ability to enable Privileged Identity Management (PIM) for the assignments.

TODO: there is currently no stage variable so this module will run into errors when you have no aad premium license.also in certain development enviroments you have to add the skip `skip_provider_registration` flag.

**Important**: The `management_groups` variable reuses the structure of the `custom_landing_zone` variable from the [caf module](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BExamples%5D-Deploy-Custom-Landing-Zone-Archetypes)

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

  custom_assignments = {
    "AMG_ALZ" = {
      pim_enabled = [true]
      "Owner"     = ["mg:ALZ"]
    }
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | ~> 2.39.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.63.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_custom_assignments"></a> [custom\_assignments](#input\_custom\_assignments) | <pre>"<group_name>" = {<br>    pim_enabled         = optional(list(string))    (list of service principals that should be added as members) <br>    "<role_identifier>" = list(string)              (<role_identifier> must be a role_definition_name or role_definition_id from azure, every element must be a scope: "mg:<mg_id>", "sub:<subscription_id>", "root" for Tenant Root Group or a full scope ID)<br>}</pre> | `map(map(list(string)))` | `{}` | no |
| <a name="input_management_groups"></a> [management\_groups](#input\_management\_groups) | <pre>[<br>  "<management_group_name>" = "<management_group_id>"    (list of management groups to recieve default group assignments) <br>]</pre> | <pre>map(object({<br>    display_name = string<br>  }))</pre> | `{}` | no |
| <a name="input_subscriptions"></a> [subscriptions](#input\_subscriptions) | <pre>[<br>  "<subscription_name>" = "<subscription_id>"    (list of subscriptions to recieve default group assignments) <br>]</pre> | `map(string)` | `{}` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_subscription_ad_groups"></a> [subscription\_ad\_groups](#output\_subscription\_ad\_groups) | All AAD Groups that have been created |

## Resource types

| Type | Used |
|------|-------|
| [azuread_group](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group) | 7 |
| [azurerm_role_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | 7 |

**`Used` only includes resource blocks.** `for_each` and `count` meta arguments, as well as resource blocks of modules are not considered.

## Modules

No modules.

## Resources by Files

### main.tf

| Name | Type |
|------|------|
| [azuread_group.custom_assignments](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group) | resource |
| [azuread_group.management_contributors](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group) | resource |
| [azuread_group.management_owners](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group) | resource |
| [azuread_group.management_readers](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group) | resource |
| [azuread_group.subscription_contributors](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group) | resource |
| [azuread_group.subscription_owners](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group) | resource |
| [azuread_group.subscription_readers](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group) | resource |
| [azurerm_role_assignment.custom_assignments](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
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