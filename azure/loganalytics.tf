resource "azurerm_log_analytics_workspace" "law" {
  name                = "prod-aks-law"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
}