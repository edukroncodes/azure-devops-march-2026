locals {
  name_prefix = "${var.project}-${var.environment}"
  compact     = lower(replace("${var.project}${var.environment}", "-", ""))

  tags = {
    project     = var.project
    environment = var.environment
    managed_by  = "terraform"
  }
}

resource "azurerm_resource_group" "this" {
  name     = "rg-${local.name_prefix}"
  location = var.location
  tags     = local.tags
}

resource "azurerm_log_analytics_workspace" "this" {
  name                = "law-${local.name_prefix}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = local.tags
}

resource "azurerm_private_dns_zone" "postgres" {
  name                = "${local.name_prefix}.postgres.database.azure.com"
  resource_group_name = azurerm_resource_group.this.name
  tags                = local.tags
}

module "vnet" {
  source = "../../modules/vnet"

  name                = "vnet-${local.name_prefix}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  address_space       = ["10.10.0.0/16"]
  tags                = local.tags

  subnets = {
    aks = {
      address_prefixes = ["10.10.0.0/20"]
    }
    app_gateway = {
      address_prefixes = ["10.10.16.0/24"]
    }
    app_service = {
      address_prefixes = ["10.10.17.0/24"]
      delegation = {
        name                       = "app-service-delegation"
        service_delegation_name    = "Microsoft.Web/serverFarms"
        service_delegation_actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
      }
    }
    postgres = {
      address_prefixes  = ["10.10.18.0/24"]
      service_endpoints = ["Microsoft.Storage"]
      delegation = {
        name                       = "postgres-delegation"
        service_delegation_name    = "Microsoft.DBforPostgreSQL/flexibleServers"
        service_delegation_actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
      }
    }
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "postgres" {
  name                  = "postgres-${local.name_prefix}"
  resource_group_name   = azurerm_resource_group.this.name
  private_dns_zone_name = azurerm_private_dns_zone.postgres.name
  virtual_network_id    = module.vnet.vnet_id
  tags                  = local.tags
}

module "acr" {
  source = "../../modules/acr"

  name                = "acr${local.compact}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  sku                 = "Premium"
  tags                = local.tags
}

module "storage" {
  source = "../../modules/storage"

  name                = "st${local.compact}001"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  replication_type    = "ZRS"
  tags                = local.tags
}

module "postgres" {
  source = "../../modules/postgres"

  name                   = "psql-${local.name_prefix}"
  resource_group_name    = azurerm_resource_group.this.name
  location               = azurerm_resource_group.this.location
  administrator_login    = var.admin_username
  administrator_password = var.admin_password
  delegated_subnet_id    = module.vnet.subnet_ids["postgres"]
  private_dns_zone_id    = azurerm_private_dns_zone.postgres.id
  sku_name               = "GP_Standard_D4s_v3"
  storage_mb             = 262144
  tags                   = local.tags

  depends_on = [azurerm_private_dns_zone_virtual_network_link.postgres]
}

module "redis" {
  source = "../../modules/redis"

  name                = "redis-${local.name_prefix}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  capacity            = 1
  shard_count         = 1
  tags                = local.tags
}

module "aks" {
  source = "../../modules/aks"

  name                       = "aks-${local.name_prefix}"
  resource_group_name        = azurerm_resource_group.this.name
  location                   = azurerm_resource_group.this.location
  dns_prefix                 = "aks-${local.name_prefix}"
  subnet_id                  = module.vnet.subnet_ids["aks"]
  log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id
  acr_id                     = module.acr.id
  authorized_ip_ranges       = var.authorized_ip_ranges
  tags                       = local.tags

  default_node_pool = {
    vm_size         = "Standard_D4ds_v5"
    min_count       = 3
    max_count       = 10
    os_disk_size_gb = 128
  }

  user_node_pools = {
    web = {
      vm_size         = "Standard_D8ds_v5"
      min_count       = 3
      max_count       = 20
      os_disk_size_gb = 128
      labels          = { workload = "web" }
    }
    workers = {
      vm_size         = "Standard_D8ds_v5"
      min_count       = 2
      max_count       = 20
      os_disk_size_gb = 128
      labels          = { workload = "workers" }
    }
  }
}

module "admin_app" {
  source = "../../modules/app_service"

  name                    = "app-${local.name_prefix}-admin"
  plan_name               = "asp-${local.name_prefix}-admin"
  resource_group_name     = azurerm_resource_group.this.name
  location                = azurerm_resource_group.this.location
  subnet_id               = module.vnet.subnet_ids["app_service"]
  docker_image_name       = "${module.acr.login_server}/admin:latest"
  autoscale_min_instances = 2
  autoscale_max_instances = 10
  tags                    = local.tags

  app_settings = {
    POSTGRES_HOST = module.postgres.fqdn
    REDIS_HOST    = module.redis.hostname
  }
}

module "app_gateway" {
  source = "../../modules/app_gateway"

  name                = "agw-${local.name_prefix}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  subnet_id           = module.vnet.subnet_ids["app_gateway"]
  backend_fqdns       = ["ecommerce.${var.environment}.internal"]
  capacity_min        = 2
  capacity_max        = 20
  tags                = local.tags
}
