variable "name" {
  description = "Virtual network name."
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

variable "address_space" {
  description = "VNet address spaces."
  type        = list(string)
}

variable "subnets" {
  description = "Subnet definitions keyed by subnet name."
  type = map(object({
    address_prefixes  = list(string)
    service_endpoints = optional(list(string), [])
    delegation = optional(object({
      name                     = string
      service_delegation_name  = string
      service_delegation_actions = list(string)
    }))
  }))
}

variable "tags" {
  description = "Tags to apply."
  type        = map(string)
  default     = {}
}
