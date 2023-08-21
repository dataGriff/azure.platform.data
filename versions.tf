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
      source  = "databricks/databricks"
      version = "1.0.0"
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

data "azurerm_client_config" "current" {}