terraform {

  cloud {
    organization = "datagriff"

    workspaces {
      name = "azure_platform_databricks"
    }
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.10.0"
    }
  }

  required_version = ">= 1.2.3"
}

provider "azurerm" {
  features {}
}