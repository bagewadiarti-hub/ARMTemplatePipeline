# terraform/variables.tf
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-demo-resources"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "westus2"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "storage_account_name" {
  description = "Storage account name"
  type        = string
}
