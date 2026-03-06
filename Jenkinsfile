// Jenkinsfile
pipeline {
    agent any
    tools {
        terraform 'terraform'
    }
    environment {
        ARM_SUBSCRIPTION_ID = credentials('azure-subscription-id')
        ARM_CLIENT_ID       = credentials('azure-client-id')
        ARM_CLIENT_SECRET   = credentials('azure-client-secret')
        ARM_TENANT_ID       = credentials('azure-tenant-id')
        VMSS_ADMIN_PASSWORD = credentials('vmss-admin-password')
    }
    parameters {
        choice(
            name: 'ENVIRONMENT',
            choices: ['dev', 'staging', 'prod'],
            description: 'Target environment'
        )
        string(
            name: 'STORAGE_ACCOUNT_NAME',
            defaultValue: 'stgdemostorage179',
            description: 'Name of the storage account'
        )
        string(
            name: 'VMSS_NAME',
            defaultValue: 'vmss-demo-dev',
            description: 'Name of the Virtual Machine Scale Set'
        )
        string(
            name: 'VMSS_ADMIN_USERNAME',
            defaultValue: 'azureuser',
            description: 'Admin username for VMSS instances'
        )
        string(
            name: 'VMSS_INSTANCE_COUNT',
            defaultValue: '1',
            description: 'Number of VMSS instances'
        )
        string(
            name: 'ADF_NAME',
            defaultValue: 'adf-demo-pipeline-dev',
            description: 'Azure Data Factory name (must be globally unique)'
        )
        string(
            name: 'ADF_SOURCE_CONTAINER',
            defaultValue: 'source-container',
            description: 'Source blob container for ADF copy pipeline'
        )
        string(
            name: 'ADF_DESTINATION_CONTAINER',
            defaultValue: 'destination-container',
            description: 'Destination blob container for ADF copy pipeline'
        )
        string(
            name: 'ADF_TRIGGER_START_TIME',
            defaultValue: '2026-01-01T00:00:00Z',
            description: 'ADF schedule trigger start time (UTC ISO 8601)'
        )
    }
    stages {
        stage('Checkout') {
            steps {
                echo "Checking out source code..."
                checkout scm
            }
        }
        stage('Terraform Version Check') {
            steps {
                echo "Checking Terraform version..."
                bat "terraform version"
            }
        }
        stage('Terraform Init') {
            steps {
                echo "Initialising Terraform..."
                dir("terraform") {
                    bat "terraform init -reconfigure -backend-config=resource_group_name=tf-rg -backend-config=storage_account_name=tfstorageprod177 -backend-config=container_name=tfstate -backend-config=key=%ENVIRONMENT%/terraform.tfstate"
                }
            }
        }
        stage('Terraform Validate') {
            steps {
                echo "Validating Terraform configuration..."
                dir("terraform") {
                    bat "terraform validate"
                }
            }
        }
        stage('Terraform Plan') {
            steps {
                echo "Running Terraform Plan..."
                dir("terraform") {
                    bat "terraform plan -var=arm_templates_path=%WORKSPACE%\\arm_templates -var-file=%ENVIRONMENT%.tfvars -var=vmss_admin_password=%VMSS_ADMIN_PASSWORD% -var=storage_account_name=%STORAGE_ACCOUNT_NAME% -var=vmss_name=%VMSS_NAME% -var=vmss_admin_username=%VMSS_ADMIN_USERNAME% -var=vmss_instance_count=%VMSS_INSTANCE_COUNT% -var=adf_name=%ADF_NAME% -var=adf_source_container=%ADF_SOURCE_CONTAINER% -var=adf_destination_container=%ADF_DESTINATION_CONTAINER% -var=adf_trigger_start_time=%ADF_TRIGGER_START_TIME% -out=tfplan"
                }
            }
        }
        stage('Terraform Apply') {
            steps {
                echo "Applying Terraform changes..."
                dir("terraform") {
                    bat "terraform apply -auto-approve tfplan"
                }
            }
        }
        stage('Output Results') {
            steps {
                echo "Fetching Terraform outputs..."
                dir("terraform") {
                    bat "terraform output"
                }
            }
        }
    }
    post {
        success {
            echo "Pipeline completed successfully! All resources deployed to rg-demo-resources."
        }
        failure {
            echo "Pipeline failed! Check logs above."
        }
        always {
            bat "if exist terraform\\tfplan del /f /q terraform\\tfplan"
        }
    }
}
