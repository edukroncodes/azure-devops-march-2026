variable "name" {
  description = "Linux Web App name."
  type        = string
}

variable "plan_name" {
  description = "App Service Plan name."
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

variable "sku_name" {
  description = "App Service Plan SKU."
  type        = string
  default     = "P1v3"
}

variable "subnet_id" {
  description = "Subnet ID for VNet integration."
  type        = string
}

variable "docker_image_name" {
  description = "Container image, for example myacr.azurecr.io/admin:latest."
  type        = string
}

variable "app_settings" {
  description = "Application settings."
  type        = map(string)
  default     = {}
  sensitive   = true
}

variable "autoscale_min_instances" {
  description = "Minimum App Service instances."
  type        = number
  default     = 2
}

variable "autoscale_max_instances" {
  description = "Maximum App Service instances."
  type        = number
  default     = 20
}

variable "tags" {
  description = "Tags to apply."
  type        = map(string)
  default     = {}
}
