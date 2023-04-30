resource "azurerm_resource_group" "rg" {
  name     = local.resource_group_name
  location = var.region
  tags     = local.tags
}

resource "azurerm_databricks_workspace" "dbw" {
  name                = local.databricks_workspace_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "standard"
  tags                = local.tags
}
resource "azurerm_storage_account" "sa" {
  name                     = local.storage_account_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = "true"
  tags                     = local.tags
}

resource "azurerm_storage_data_lake_gen2_filesystem" "lake_container" {
  name               = "lake"
  storage_account_id = azurerm_storage_account.sa.id
}

resource "azurerm_storage_data_lake_gen2_filesystem" "events_container" {
  name               = "events"
  storage_account_id = azurerm_storage_account.sa.id
}

resource "azurerm_eventhub_namespace" "ehns" {
  name                = local.eventhub_namespace_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"
  capacity            = 1
  tags                = local.tags
}