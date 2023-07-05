variable "subscriptions" {
  type        = map(list(string))
  description = "list of subscriptions to recieve default group assignments"
  default     = {}
}

variable "group_assignments" {
  type        = map(map(list(string)))
  description = <<-DOC
  ```
  "<group_name>" = {
    service_principals = optional(list(string))    (list of service principals that should be added as members) 
    "<role>"           = list(string)              (<role> must be a role_definition_name or role_definition_id from azure, every element must be a scope: "mg:<mg_id>", "sub:<subscription_id>", "root" for Tenant Root Group or a full scope ID)
}
  ```
  DOC
  default     = {}
}


variable "pim_enabled_groups" {
  type        = list(string)
  description = <<-DOC
  ```
  pim_enabled_groups = ["groupA", "groupB"]     (sets the value of assignable_to_role to true)
  ```
  DOC
  default     = []
}
