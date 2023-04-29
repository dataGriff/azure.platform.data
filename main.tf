resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = "northeurope"
  tags = {
    environment = "dev"
    team        = "DataGriff"
    domain      = "learning"
  }
}

resource "azurerm_databricks_workspace" "dbw" {
  name                = "dv-learning-dbw-eun-dgrf"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "standard"
  tags = {
    environment = "dev"
    team        = "DataGriff"
    domain      = "learning"
  }
}
