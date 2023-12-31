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

variable "custom_groups" {
  type = map(object({
    azuread_role_assignable = optional(bool)
    role_assignments = map(list(string))
  }))
  description = <<-DOC
  ```
  "<group_name>" = {
    azuread_role_assignable = optional(string)    (if you want to assign Azure AD roles to the group) 
    role_assignments = {
      "<role_assignment>" = [                 (must be a role_definition_name or role_definition_id from azure)
        "<scope>"                             (every element must be a scope: "mg:<mg_id>", "sub:<subscription_id>", "root" for Tenant Root Group or a full scope ID)
      ]
    }
}
  ```
  DOC
  default     = {}
  validation {
    condition = can(length([
      for group_key, group in var.custom_groups :
      regex("^AMG_|^SUB_", group_key) == null ? 0 : 1
    ]) == length(var.custom_groups))
    error_message = "Custom role assignment names must start with AMG_ or SUB_ respectively"
  }
}
