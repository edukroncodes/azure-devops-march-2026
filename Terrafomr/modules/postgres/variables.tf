variable "name" {
  description = "PostgreSQL Flexible Server name."
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

variable "administrator_login" {
  description = "Database administrator username."
  type        = string
}

variable "administrator_password" {
  description = "Database administrator password."
  type        = string
  sensitive   = true
}

variable "delegated_subnet_id" {
  description = "Delegated subnet ID for private PostgreSQL."
  type        = string
}

variable "private_dns_zone_id" {
  description = "Private DNS zone ID."
  type        = string
}

variable "sku_name" {
  description = "PostgreSQL SKU."
  type        = string
  default     = "GP_Standard_D8s_v3"
}

variable "storage_mb" {
  description = "Storage size in MB."
  type        = number
  default     = 524288
}

variable "databases" {
  description = "Databases to create."
  type        = set(string)
  default     = ["commerce"]
}

variable "tags" {
  description = "Tags to apply."
  type        = map(string)
  default     = {}
}
