output "state_resource_group_name" {
  description = "Terraform state resource group."
  value       = azurerm_resource_group.tfstate.name
}

output "state_storage_account_name" {
  description = "Terraform state storage account."
  value       = azurerm_storage_account.tfstate.name
}

output "state_container_name" {
  description = "Terraform state container."
  value       = azurerm_storage_container.tfstate.name
}
