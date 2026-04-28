resource "azurerm_postgresql_flexible_server" "this" {
  name                          = var.name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  version                       = "16"
  administrator_login           = var.administrator_login
  administrator_password        = var.administrator_password
  delegated_subnet_id           = var.delegated_subnet_id
  private_dns_zone_id           = var.private_dns_zone_id
  public_network_access_enabled = false
  zone                          = "1"
  sku_name                      = var.sku_name
  storage_mb                    = var.storage_mb
  backup_retention_days         = 35
  geo_redundant_backup_enabled  = true
  tags                          = var.tags

  high_availability {
    mode                      = "ZoneRedundant"
    standby_availability_zone = "2"
  }

  lifecycle {
    ignore_changes = [zone, high_availability[0].standby_availability_zone]
  }
}

resource "azurerm_postgresql_flexible_server_database" "this" {
  for_each = var.databases

  name      = each.value
  server_id = azurerm_postgresql_flexible_server.this.id
  collation = "en_US.utf8"
  charset   = "UTF8"
}

resource "azurerm_postgresql_flexible_server_configuration" "connections" {
  name      = "max_connections"
  server_id = azurerm_postgresql_flexible_server.this.id
  value     = "5000"
}
