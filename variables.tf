variable "region" {
  type        = string
  default     = "northeurope"
  description = "The is the Azure region the resources will be deployed into."
  validation {
    condition     = contains(["northeurope", "westeurope"], var.region)
    error_message = "The region is not in the correct region."
  }
}

variable "environment" {
  type        = string
  default     = "learning"
  description = "The is the environment the resources belong to. e.g. learning, development, production."
  validation {
    condition     = contains(["learning", "development", "production"], var.environment)
    error_message = "The environment is not valid."
  }
}

variable "team" {
  type        = string
  default     = "datagriff"
  description = "The is the team that own the resources."
  validation {
    condition     = contains(["datagriff", "hungovercoders", "dogadopt"], var.team)
    error_message = "The team is not valid."
  }
}

variable "organisation" {
  type        = string
  default     = "datagriff"
  description = "The is the organisation that owns the resources."
  validation {
    condition     = contains(["datagriff", "hungovercoders", "dogadopt"], var.organisation)
    error_message = "The organisation is not valid."
  }
}

variable "domain" {
  type        = string
  default     = "data"
  description = "The is the business problem domain being solved by the resources."
}

variable "azure_namespace" {
  type        = string
  default     = "dgrf"
  description = "The is the unique namespace added to resources."
}

locals {
  region_shortcode                  = (var.region == "northeurope" ? "eun" : var.region == "westeurope" ? "euw" : "unk")
  environment_shortcode             = (var.environment == "learning" ? "lrn" : var.environment == "development" ? "dev" : var.environment == "production" ? "prd" : "unk")
  resource_group_name               = "${local.environment_shortcode}-${var.domain}-rg"
  storage_account_name              = "${local.environment_shortcode}${var.domain}sa${local.region_shortcode}${var.azure_namespace}"
  eventhub_namespace_name           = "${local.environment_shortcode}-${var.team}-ehns-${local.region_shortcode}-${var.azure_namespace}"
  databricks_workspace_name         = "${local.environment_shortcode}-${var.team}-dbw-${local.region_shortcode}-${var.azure_namespace}"
  databricks_workspace_rg           = "databricks-rg-${local.resource_group_name}"
  databricks_premium_workspace_name = "${local.environment_shortcode}-${var.team}-dbwp-${local.region_shortcode}-${var.azure_namespace}"
  databricks_premium_workspace_rg   = "databricks-premium-rg-${local.resource_group_name}"
  cosmos_sql_name                   = "${local.environment_shortcode}-${var.domain}-cosdbsql-${local.region_shortcode}-${var.azure_namespace}"
  apim_name                         = "${local.environment_shortcode}-${var.organisation}-apim-${local.region_shortcode}-${var.azure_namespace}"
  tags = {
    environment = var.environment
    team        = var.team
    domain      = var.domain
  }
}

