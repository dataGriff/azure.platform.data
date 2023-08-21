resource "azurerm_resource_group" "rg" {
  name     = local.resource_group_name
  location = var.region
  tags     = local.tags
}

resource "azurerm_databricks_workspace" "dbw" {
  name                        = local.databricks_workspace_name
  resource_group_name         = azurerm_resource_group.rg.name
  location                    = azurerm_resource_group.rg.location
  sku                         = "standard"
  tags                        = local.tags
  managed_resource_group_name = local.databricks_workspace_rg
}

resource "azurerm_databricks_workspace" "dbwp" {
  name                        = local.databricks_premium_workspace_name
  resource_group_name         = azurerm_resource_group.rg.name
  location                    = azurerm_resource_group.rg.location
  sku                         = "premium"
  tags                        = local.tags
  managed_resource_group_name = local.databricks_premium_workspace_rg
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

resource "azurerm_storage_data_lake_gen2_filesystem" "metastore_container" {
  name               = "metastore"
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

resource "azurerm_cosmosdb_account" "cosdbsql" {
  name                      = local.cosmos_sql_name
  location                  = azurerm_resource_group.rg.location
  resource_group_name       = azurerm_resource_group.rg.name
  offer_type                = "Standard"
  kind                      = "GlobalDocumentDB"
  enable_automatic_failover = false
  enable_free_tier          = true
  tags                      = local.tags

  capabilities {
    name = "EnableServerless"
  }

  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 300
    max_staleness_prefix    = 100000
  }

  geo_location {
    location          = azurerm_resource_group.rg.location
    failover_priority = 0
  }
}

resource "azurerm_cosmosdb_account" "cosdbmon" {
  name                      = local.cosmos_mon_name
  location                  = azurerm_resource_group.rg.location
  resource_group_name       = azurerm_resource_group.rg.name
  offer_type                = "Standard"
  kind                      = "MongoDB"
  enable_automatic_failover = false
  enable_free_tier          = false
  tags                      = local.tags


  capabilities {
    name = "EnableServerless"

  }
  capabilities {
    name = "EnableMongo"
  }

  mongo_server_version = "4.2"

  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 300
    max_staleness_prefix    = 100000

  }



  geo_location {
    location          = azurerm_resource_group.rg.location
    failover_priority = 0
  }
}

resource "azurerm_api_management" "apim" {
  name                = local.apim_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  publisher_name      = "dataGriff"
  publisher_email     = "info@hungovercoders.com"
  sku_name            = "Consumption_0"
  tags                = local.tags
}

resource "azurerm_container_registry" "acr" {
  name                = local.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = true
  tags                = local.tags
}

resource "azurerm_key_vault" "kv" {
  name                        = local.key_vault_name
  location                    = azurerm_resource_group.rg.location
  resource_group_name         = azurerm_resource_group.rg.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  sku_name                    = "standard"
  tags                        = local.tags
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Set",
      "Get",
      "Delete",
      "List"
    ]
  }
}

resource "azurerm_data_factory" "adf" {
  name                = local.data_factory_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.tags
}

resource "azurerm_search_service" "search" {
  name                = local.cognitive_search_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "free"
  replica_count       = 1
  partition_count     = 1
  tags                = local.tags
}

resource "azapi_resource" "access_connector" {
  type      = "Microsoft.Databricks/accessConnectors@2022-04-01-preview"
  name      = local.databricks_external_connector
  location  = azurerm_resource_group.rg.location
  parent_id = azurerm_resource_group.rg.id
  identity { type = "SystemAssigned" }
  body = jsonencode({ properties = {} })
}

resource "azurerm_role_assignment" "access_assign" {
  scope                = azurerm_storage_account.sa.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azapi_resource.access_connector.identity[0].principal_id
}

resource "databricks_metastore" "metastore" {
  name = local.databricks_metastore
  storage_root = format("abfss://%s@%s.dfs.core.windows.net/",
    azurerm_storage_data_lake_gen2_filesystem.metastore_container.name,
  azurerm_storage_account.sa.name)
  force_destroy = true
}

resource "databricks_metastore_data_access" "metastore_data_access" {
  depends_on   = [databricks_metastore.metastore]
  metastore_id = databricks_metastore.metastore.id
  name         = local.databricks_metastore_access
  azure_managed_identity {
    access_connector_id = azapi_resource.access_connector.id
  }
  is_default = true
}

resource "databricks_metastore_assignment" "default_metastore" {
  depends_on           = [databricks_metastore_data_access.metastore_data_access]
  workspace_id         = azurerm_databricks_workspace.dbwp.workspace_id
  metastore_id         = databricks_metastore.metastore.id
  default_catalog_name = local.databricks_metastore_default
}
