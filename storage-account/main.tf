resource "azurerm_storage_account" "storage-account" {
  for_each = {
    for k, v in var.storage_accounts : k => v
    if v.storage_account_config.tier != null
  }

  name                      = each.value.storage_account_config.name
  resource_group_name      = data.azurerm_resource_group.rg[each.value.resource_group_name].name
  location                 = data.azurerm_resource_group.rg[each.value.resource_group_name].location
  account_tier             = each.value.storage_account_config.tier
  account_replication_type = each.value.storage_account_config.replication_type
  account_kind              = each.value.storage_account_config.kind
  min_tls_version           = each.value.storage_account_config.min_tls_version
  https_traffic_only_enabled       = each.value.storage_account_config.https_traffic_only
  allow_nested_items_to_be_public = each.value.storage_account_config.allow_nested_items_public
  shared_access_key_enabled       = each.value.storage_account_config.shared_access_key_enabled
  tags = each.value.storage_account_config.tags
}

resource "azurerm_private_endpoint" "pe" {
  for_each = {
    for k, v in var.storage_accounts : k => v
    if v.storage_account_config.tier != null && v.private_endpoint_config != null
  }

  name                = each.value.private_endpoint_config.name
  location            = data.azurerm_resource_group.rg[each.value.resource_group_name].location
  resource_group_name = data.azurerm_resource_group.rg[each.value.resource_group_name].name
  subnet_id           = data.azurerm_subnet.subnet[each.key].id

  private_service_connection {
    name                           = each.value.private_endpoint_config.name
    private_connection_resource_id = azurerm_storage_account.storage-account[each.key].id
    subresource_names              = each.value.private_endpoint_config.subresource_names
    is_manual_connection           = each.value.private_endpoint_config.is_manual_connection
  }
}
