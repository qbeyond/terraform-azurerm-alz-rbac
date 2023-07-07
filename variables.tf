variable "subscriptions" {
  type        = map(string)
  description = "Mapping of subscription names to subscription IDs."
  default     = {}
}

variable "management_groups" {
  type = map(object({
    display_name = string
  }))
  description = <<-DOC
  ```
    "<management_group_id>" = {                 (this variable is reusing the structure of the management groups for custom_landing_zones from the caf module )
      displayName = "<management_group_name>"
    }
  ```
  DOC
  default     = {}
}

variable "custom_assignments" {
  type = map(object({
    pim_enabled      = optional(string)
    role_identifiers = list(string)
  }))
  description = <<-DOC
  ```
  "<group_name>" = {
    pim_enabled         = optional(string)    (if you want the role assignment to be pimmable) 
    "<role_identifier>" = list(string)        (<role_identifier> must be a role_definition_name or role_definition_id from azure, every element must be a scope: "mg:<mg_id>", "sub:<subscription_id>", "root" for Tenant Root Group or a full scope ID)
}
  ```
  DOC
  default     = {}
  validation {
    condition     = can(regex("^AMG_|^SUB_", keys(var.custom_assignments)))
    error_message = "Custom role assignment names must start with AMG_ or SUB_ respectively"
  }
}
