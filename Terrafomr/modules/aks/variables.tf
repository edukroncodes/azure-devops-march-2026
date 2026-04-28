variable "name" {
  description = "AKS cluster name."
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

variable "dns_prefix" {
  description = "AKS DNS prefix."
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version. Leave null for Azure default."
  type        = string
  default     = null
}

variable "subnet_id" {
  description = "AKS subnet ID."
  type        = string
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics workspace ID."
  type        = string
}

variable "acr_id" {
  description = "ACR ID to grant AcrPull. Leave null to skip."
  type        = string
  default     = null
}

variable "default_node_pool" {
  description = "Default system node pool."
  type = object({
    vm_size        = string
    min_count      = number
    max_count      = number
    os_disk_size_gb = number
  })
}

variable "user_node_pools" {
  description = "Additional user node pools keyed by pool name."
  type = map(object({
    vm_size        = string
    min_count      = number
    max_count      = number
    os_disk_size_gb = number
    labels         = optional(map(string), {})
    taints         = optional(list(string), [])
  }))
  default = {}
}

variable "authorized_ip_ranges" {
  description = "Public IP CIDRs allowed to reach the Kubernetes API."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to apply."
  type        = map(string)
  default     = {}
}
