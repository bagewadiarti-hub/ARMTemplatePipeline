terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.117.1"
    }
  }
  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

# -------------------------------------------------------
# Data source - existing resource group
# -------------------------------------------------------
data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

# -------------------------------------------------------
# Storage Account (existing from previous deployment)
# -------------------------------------------------------
resource "azurerm_resource_group_template_deployment" "storage" {
  name                = "storage-arm-deployment"
  resource_group_name = data.azurerm_resource_group.main.name
  deployment_mode     = "Incremental"

  template_content = file("${path.module}/../arm_templates/storage.json")

  parameters_content = jsonencode({
    storageAccountName = { value = var.storage_account_name }
    environment        = { value = var.environment }
    skuName            = { value = "Standard_LRS" }
  })

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# -------------------------------------------------------
# VMSS - Ubuntu 22.04 LTS
# -------------------------------------------------------
resource "azurerm_resource_group_template_deployment" "vmss" {
  name                = "vmss-arm-deployment"
  resource_group_name = data.azurerm_resource_group.main.name
  deployment_mode     = "Incremental"

  template_content = file("${path.module}/../arm_templates/vmss.json")

  parameters_content = jsonencode({
    vmssName       = { value = var.vmss_name }
    adminUsername  = { value = var.vmss_admin_username }
    adminPassword  = { value = var.vmss_admin_password }
    instanceCount  = { value = var.vmss_instance_count }
    environment    = { value = var.environment }
  })

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# -------------------------------------------------------
# Azure Data Factory
# -------------------------------------------------------
resource "azurerm_resource_group_template_deployment" "adf" {
  name                = "adf-arm-deployment"
  resource_group_name = data.azurerm_resource_group.main.name
  deployment_mode     = "Incremental"

  template_content = file("${path.module}/../arm_templates/adf.json")

  parameters_content = jsonencode({
    adfName     = { value = var.adf_name }
    environment = { value = var.environment }
  })

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# -------------------------------------------------------
# ADF Pipeline & Trigger (depends on ADF being created)
# -------------------------------------------------------
resource "azurerm_resource_group_template_deployment" "adf_pipeline" {
  name                = "adf-pipeline-arm-deployment"
  resource_group_name = data.azurerm_resource_group.main.name
  deployment_mode     = "Incremental"

  template_content = file("${path.module}/../arm_templates/adf_pipeline_trigger.json")

  parameters_content = jsonencode({
    adfName                    = { value = var.adf_name }
    sourceStorageAccountName   = { value = var.storage_account_name }
    sourceStorageAccountKey    = { value = var.storage_account_key }
    sourceContainerName        = { value = var.adf_source_container }
    destinationContainerName   = { value = var.adf_destination_container }
    environment                = { value = var.environment }
    triggerStartTime           = { value = var.adf_trigger_start_time }
  })

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }

  depends_on = [azurerm_resource_group_template_deployment.adf]
}
