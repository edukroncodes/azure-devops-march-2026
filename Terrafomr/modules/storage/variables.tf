variable "name" {
  description = "Globally unique storage account name."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "containers" {
  description = "Blob containers to create."
  type        = set(string)
  default     = ["catalog-media", "invoices", "logs"]
}

variable "account_tier" {
  description = "Storage account tier."
  type        = string
  default     = "Standard"
}

variable "replication_type" {
  description = "Storage replication type."
  type        = string
  default     = "ZRS"
}

variable "tags" {
  description = "Tags to apply."
  type        = map(string)
  default     = {}
}
