# Module
[![GitHub tag](https://img.shields.io/github/tag/qbeyond/terraform-module-template.svg)](https://registry.terraform.io/modules/qbeyond/terraform-module-template/provider/latest)
[![License](https://img.shields.io/github/license/qbeyond/terraform-module-template.svg)](https://github.com/qbeyond/terraform-module-template/blob/main/LICENSE)

----

This is a template module. It just showcases how a module should look. This would be a short description of the module.

<!-- BEGIN_TF_DOCS -->
## Usage

It's very easy to use!
```hcl
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
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | ~> 2.15.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 2.77.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_group_assignments"></a> [group\_assignments](#input\_group\_assignments) | <pre>"<group_name>" = {<br>    service_principals = optional(list(string))    (list of service principals that should be added as members) <br>    "<role>"           = list(string)              (<role> must be a role_definition_name or role_definition_id from azure, every element must be a scope: "mg:<mg_id>", "sub:<subscription_id>", "root" for Tenant Root Group or a full scope ID)<br>}</pre> | `map(map(list(string)))` | `{}` | no |
| <a name="input_pim_enabled_groups"></a> [pim\_enabled\_groups](#input\_pim\_enabled\_groups) | <pre>pim_enabled_groups = ["groupA", "groupB"]     (sets the value of assignable_to_role to true)</pre> | `list(string)` | `[]` | no |
| <a name="input_subscriptions"></a> [subscriptions](#input\_subscriptions) | list of subscriptions to recieve default group assignments | `map(list(string))` | `{}` | no |
## Outputs

No outputs.

## Resource types

| Type | Used |
|------|-------|
| [azuread_group](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group) | 1 |
| [azurerm_role_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | 1 |

**`Used` only includes resource blocks.** `for_each` and `count` meta arguments, as well as resource blocks of modules are not considered.

## Modules

No modules.

## Resources by Files

### main.tf

| Name | Type |
|------|------|
| [azuread_group.groups](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group) | resource |
| [azurerm_role_assignment.role_assignments](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
<!-- END_TF_DOCS -->

## Contribute

Please use Pull requests to contribute.

When a new Feature or Fix is ready to be released, create a new Github release and adhere to [Semantic Versioning 2.0.0](https://semver.org/lang/de/spec/v2.0.0.html).