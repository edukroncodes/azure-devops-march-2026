resource "azurerm_redis_cache" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  capacity            = var.capacity
  family              = var.family
  sku_name            = var.sku_name
  shard_count         = var.sku_name == "Premium" ? var.shard_count : null
  minimum_tls_version = "1.2"
  zones               = var.sku_name == "Premium" ? ["1", "2", "3"] : null
  tags                = var.tags

  redis_configuration {
    maxmemory_policy = "allkeys-lru"
  }
}
