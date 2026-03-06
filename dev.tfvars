# -------------------------------------------------------
# dev.tfvars — Development environment variable values
# NOTE: Do NOT commit storage_account_key, vmss_admin_password
#       to source control. Pass them via Jenkins credentials.
# -------------------------------------------------------

environment         = "dev"
resource_group_name = "rg-demo-resources"

# Storage
storage_account_name = "stgdemostorage179"

# VMSS
vmss_name           = "vmss-demo-arm-101r"
vmss_admin_username = "azureuser"
vmss_instance_count = 1

# ADF
adf_name                  = "adf-demo-pipeline-dev"
adf_source_container      = "source-container"
adf_destination_container = "destination-container"
adf_trigger_start_time    = "2026-01-01T00:00:00Z"
