variable "project" {
  description = "Project name."
  type        = string
  default     = "ecommerce"
}

variable "location" {
  description = "Azure region."
  type        = string
  default     = "eastus2"
}

variable "state_storage_account_name" {
  description = "Globally unique Terraform state storage account name."
  type        = string
  default     = "tfstateecomshared"
}
