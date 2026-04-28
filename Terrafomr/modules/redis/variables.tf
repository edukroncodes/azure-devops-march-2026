variable "name" {
  description = "Redis cache name."
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

variable "capacity" {
  description = "Redis capacity."
  type        = number
  default     = 2
}

variable "family" {
  description = "Redis family."
  type        = string
  default     = "P"
}

variable "sku_name" {
  description = "Redis SKU."
  type        = string
  default     = "Premium"
}

variable "shard_count" {
  description = "Number of shards for Premium clustering."
  type        = number
  default     = 2
}

variable "tags" {
  description = "Tags to apply."
  type        = map(string)
  default     = {}
}
