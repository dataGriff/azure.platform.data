terraform {

  cloud {
    organization = "datagriff"

    workspaces {
      name = "learn_azure_platform_data"
    }
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.54.0"
    }
    databricks = {
      source = "databricks/databricks"
    }
    azapi = {
      source = "Azure/azapi"
    }
  }

  required_version = ">= 1.2.3"
}

provider "azapi" {
}

provider "azurerm" {
  features {}
}
provider "databricks" {
  azure_workspace_resource_id = azurerm_databricks_workspace.dbwp.id
}

data "azurerm_client_config" "current" {}