output "shared_resource_group_name" {
  description = "Shared root resource group."
  value       = azurerm_resource_group.shared.name
}
