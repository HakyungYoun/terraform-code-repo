variable "storage_accounts" {
  type = map(object({
    resource_group_name = string
    vnet_name            = optional(string, "")
    subnet_name          = optional(string, "")

    storage_account_config = object({
      name             = string
      tier             = optional(string)
      replication_type = optional(string)
      kind             = optional(string)
      min_tls_version  = optional(string)
      tags             = optional(map(string))
      https_traffic_only        = optional(bool)
      allow_nested_items_public = optional(bool)
      shared_access_key_enabled = optional(bool)
    })

    private_endpoint_config = optional(object({
      name                 = string
      subresource_names    = optional(list(string))
      is_manual_connection = optional(bool)
    }))
  }))
  default = {}
}
