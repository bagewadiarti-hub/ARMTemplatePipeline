# terraform/outputs.tf
output "resource_group_name" {
  description = "Name of the created resource group"
  value       = azurerm_resource_group.main.name
}

output "arm_deployment_name" {
  description = "Name of the ARM deployment"
  value       = azurerm_resource_group_template_deployment.storage.name
}

output "arm_deployment_outputs" {
  description = "Outputs from the ARM template"
  value       = jsondecode(azurerm_resource_group_template_deployment.storage.output_content)
}
