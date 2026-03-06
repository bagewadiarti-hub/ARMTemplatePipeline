# -------------------------------------------------------
# Storage Account Outputs
# -------------------------------------------------------
output "storage_deployment_name" {
  value       = azurerm_resource_group_template_deployment.storage.name
  description = "Storage ARM deployment name"
}

output "storage_deployment_outputs" {
  value       = jsondecode(azurerm_resource_group_template_deployment.storage.output_content)
  description = "Storage account deployment outputs"
}

# -------------------------------------------------------
# VMSS Outputs
# -------------------------------------------------------
output "vmss_deployment_name" {
  value       = azurerm_resource_group_template_deployment.vmss.name
  description = "VMSS ARM deployment name"
}

output "vmss_deployment_outputs" {
  value       = jsondecode(azurerm_resource_group_template_deployment.vmss.output_content)
  description = "VMSS deployment outputs including load balancer public IP"
}

# -------------------------------------------------------
# ADF Outputs
# -------------------------------------------------------
output "adf_deployment_name" {
  value       = azurerm_resource_group_template_deployment.adf.name
  description = "ADF ARM deployment name"
}

output "adf_deployment_outputs" {
  value       = jsondecode(azurerm_resource_group_template_deployment.adf.output_content)
  description = "ADF deployment outputs including factory ID and principal ID"
}

# -------------------------------------------------------
# ADF Pipeline & Trigger Outputs
# -------------------------------------------------------
output "adf_pipeline_deployment_name" {
  value       = azurerm_resource_group_template_deployment.adf_pipeline.name
  description = "ADF pipeline ARM deployment name"
}

output "adf_pipeline_outputs" {
  value       = jsondecode(azurerm_resource_group_template_deployment.adf_pipeline.output_content)
  description = "ADF pipeline and trigger deployment outputs"
}

# -------------------------------------------------------
# Summary
# -------------------------------------------------------
output "resource_group_name" {
  value       = data.azurerm_resource_group.main.name
  description = "Resource group all resources are deployed to"
}
