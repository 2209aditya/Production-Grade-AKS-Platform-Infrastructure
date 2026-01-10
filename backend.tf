terraform {
  backend "azurerm" {
    resource_group_name  = "tf-backend-rg"
    storage_account_name = "tfbackendprod"
    container_name       = "tfstate"
    key                  = "aks-platform.tfstate"
  }
}
