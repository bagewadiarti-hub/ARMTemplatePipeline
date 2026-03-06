# -------------------------------------------------------
# General
# -------------------------------------------------------
variable "environment" {
  type        = string
  description = "Target environment (dev / staging / prod)"
}

variable "resource_group_name" {
  type        = string
  description = "Existing resource group name"
  default     = "rg-demo-resources"
}

# -------------------------------------------------------
# Storage Account
# -------------------------------------------------------
variable "storage_account_name" {
  type        = string
  description = "Name of the storage account (used for ADF linked service too)"
  default     = "stgdemostorage179"
}

# -------------------------------------------------------
# VMSS
# -------------------------------------------------------
variable "vmss_name" {
  type        = string
  description = "Name of the Virtual Machine Scale Set"
  default     = "vmss-demo-arm-144"
}

variable "vmss_admin_username" {
  type        = string
  description = "Admin username for VMSS instances"
  default     = "azureuser"
}

variable "vmss_admin_password" {
  type        = string
  sensitive   = true
  description = "Admin password for VMSS instances (min 12 chars, mixed case + number + special)"
}

variable "vmss_instance_count" {
  type        = number
  description = "Number of VMSS instances to deploy"
  default     = 1
}

# -------------------------------------------------------
# Azure Data Factory
# -------------------------------------------------------
variable "adf_name" {
  type        = string
  description = "Name of the Azure Data Factory (must be globally unique)"
  default     = "adf-demo-pipeline-dev"
}

variable "adf_source_container" {
  type        = string
  description = "Source blob container name for ADF copy pipeline"
  default     = "source-container"
}

variable "adf_destination_container" {
  type        = string
  description = "Destination blob container name for ADF copy pipeline"
  default     = "destination-container"
}

variable "adf_trigger_start_time" {
  type        = string
  description = "Schedule trigger start time in UTC ISO 8601 format"
  default     = "2026-01-01T00:00:00Z"
}
