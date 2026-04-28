terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate-shared"
    storage_account_name = "tfstateecomshared"
    container_name       = "tfstate"
    key                  = "ecommerce/root.tfstate"
  }
}
