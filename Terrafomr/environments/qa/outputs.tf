output "resource_group_name" {
  description = "Environment resource group."
  value       = azurerm_resource_group.this.name
}

output "acr_login_server" {
  description = "Container registry login server."
  value       = module.acr.login_server
}

output "aks_cluster_name" {
  description = "AKS cluster name."
  value       = module.aks.name
}

output "application_gateway_public_ip" {
  description = "Application Gateway public IP."
  value       = module.app_gateway.public_ip_address
}

output "postgres_fqdn" {
  description = "PostgreSQL private FQDN."
  value       = module.postgres.fqdn
}
