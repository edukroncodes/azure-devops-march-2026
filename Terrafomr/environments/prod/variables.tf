variable "project" {
  description = "Project name used in resource names."
  type        = string
  default     = "ecommerce"
}

variable "environment" {
  description = "Deployment environment."
  type        = string
  default     = "prod"
}

variable "location" {
  description = "Azure region."
  type        = string
  default     = "eastus2"
}

variable "admin_username" {
  description = "PostgreSQL administrator username."
  type        = string
  default     = "pgadmin"
}

variable "admin_password" {
  description = "PostgreSQL administrator password."
  type        = string
  sensitive   = true
}

variable "authorized_ip_ranges" {
  description = "CIDR ranges allowed to access the AKS API server."
  type        = list(string)
  default     = []
}
