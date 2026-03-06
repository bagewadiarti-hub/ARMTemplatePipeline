# terraform/main.tf

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  required_version = ">= 1.3.0"
}

# azurerm provider automatically picks up ARM_* environment variables
# set in Jenkins — no need to pass credentials explicitly here
provider "azurerm" {
  features {}
}

# Create Resource Group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# Deploy ARM Template via Terraform
resource "azurerm_resource_group_template_deployment" "storage" {
  name                = "storage-arm-deployment"
  resource_group_name = azurerm_resource_group.main.name
  deployment_mode     = "Incremental"

  template_content = file("${path.module}/arm_templates/storage_account.json")

  parameters_content = jsonencode({
    storageAccountName = {
      value = var.storage_account_name
    }
    location = {
      value = var.location
    }
    skuName = {
      value = "Standard_LRS"
    }
    environment = {
      value = var.environment
    }
  })

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}
