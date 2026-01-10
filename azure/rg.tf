resource "azurerm_resource_group" "rg" {
  name     = "prod-aks-rg"
  location = var.location
}
