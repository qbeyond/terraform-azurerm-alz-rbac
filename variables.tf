variable "subscriptions" {
  type        = map(string)
  description = <<-DOC
  ```
  [
    "<subscription_displayName>" = "<subscription_group_id>"    (list of subscriptions to recieve default group assignments) 
  ]
  ```
  DOC
  default     = {}
}

variable "management_groups" {
  type        = map(string)
  description = <<-DOC
  ```
  [
    "<management_group_name>" = "<management_group_id>"    (list of management groups to recieve default group assignments) 
  ]
  ```
  DOC
  default     = {}
}

variable "custom_assignments" {
  type        = map(map(list(string)))
  description = <<-DOC
  ```
  "<group_name>" = {
    pim_enabled         = optional(list(string))    (list of service principals that should be added as members) 
    "<role_identifier>" = list(string)              (<role_identifier> must be a role_definition_name or role_definition_id from azure, every element must be a scope: "mg:<mg_id>", "sub:<subscription_id>", "root" for Tenant Root Group or a full scope ID)
}
  ```
  DOC
  default     = {}
}
