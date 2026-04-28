variable "name" {
  description = "Application Gateway name."
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

variable "subnet_id" {
  description = "Application Gateway subnet ID."
  type        = string
}

variable "backend_fqdns" {
  description = "Backend FQDNs for the ecommerce frontend/API."
  type        = list(string)
}

variable "capacity_min" {
  description = "Minimum autoscale capacity."
  type        = number
  default     = 2
}

variable "capacity_max" {
  description = "Maximum autoscale capacity."
  type        = number
  default     = 125
}

variable "tags" {
  description = "Tags to apply."
  type        = map(string)
  default     = {}
}
