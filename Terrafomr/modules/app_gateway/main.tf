resource "azurerm_public_ip" "this" {
  name                = "${var.name}-pip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1", "2", "3"]
  tags                = var.tags
}

resource "azurerm_application_gateway" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  sku {
    name = "WAF_v2"
    tier = "WAF_v2"
  }

  autoscale_configuration {
    min_capacity = var.capacity_min
    max_capacity = var.capacity_max
  }

  gateway_ip_configuration {
    name      = "gateway-ip"
    subnet_id = var.subnet_id
  }

  frontend_ip_configuration {
    name                 = "public"
    public_ip_address_id = azurerm_public_ip.this.id
  }

  frontend_port {
    name = "http"
    port = 80
  }

  backend_address_pool {
    name  = "ecommerce"
    fqdns = var.backend_fqdns
  }

  backend_http_settings {
    name                  = "http"
    cookie_based_affinity = "Disabled"
    path                  = "/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
    probe_name            = "health"
  }

  http_listener {
    name                           = "http"
    frontend_ip_configuration_name = "public"
    frontend_port_name             = "http"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "ecommerce"
    rule_type                  = "Basic"
    http_listener_name         = "http"
    backend_address_pool_name  = "ecommerce"
    backend_http_settings_name = "http"
    priority                   = 100
  }

  probe {
    name                = "health"
    protocol            = "Http"
    host                = "127.0.0.1"
    path                = "/healthz"
    interval            = 30
    timeout             = 30
    unhealthy_threshold = 3
  }

  waf_configuration {
    enabled          = true
    firewall_mode    = "Prevention"
    rule_set_type    = "OWASP"
    rule_set_version = "3.2"
  }
}
