locals {
  tags = {
    project    = var.project
    scope      = "root"
    managed_by = "terraform"
  }
}

resource "azurerm_resource_group" "shared" {
  name     = "rg-${var.project}-shared"
  location = var.location
  tags     = local.tags
}
