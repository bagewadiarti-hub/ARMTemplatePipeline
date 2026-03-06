// Jenkinsfile
pipeline {
    agent any

    environment {
        TF_VERSION = "1.6.0"
        TF_DIR     = "terraform"

        ARM_SUBSCRIPTION_ID = credentials('azure-subscription-id')
        ARM_CLIENT_ID       = credentials('azure-client-id')
        ARM_CLIENT_SECRET   = credentials('azure-client-secret')
        ARM_TENANT_ID       = credentials('azure-tenant-id')
    }

    parameters {
        choice(
            name: 'ACTION',
            choices: ['plan', 'apply'],
            description: 'Terraform action to perform'
        )
        choice(
            name: 'ENVIRONMENT',
            choices: ['dev', 'staging', 'prod'],
            description: 'Target environment'
        )
        string(
            name: 'STORAGE_ACCOUNT_NAME',
            defaultValue: 'stdemostorage001',
            description: 'Name of the storage account to create'
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
                dir("${TF_DIR}") {
                    bat "terraform init -backend-config=resource_group_name=tf-rg -backend-config=storage_account_name=tfstorageprod177 -backend-config=container_name=tfstate -backend-config=key=%ENVIRONMENT%/terraform.tfstate"
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                echo "Validating Terraform configuration..."
                dir("${TF_DIR}") {
                    bat "terraform validate"
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                echo "Running Terraform Plan..."
                dir("${TF_DIR}") {
                    bat "terraform plan -var=environment=%ENVIRONMENT% -var=storage_account_name=%STORAGE_ACCOUNT_NAME% -out=tfplan"
                }
            }
        }

        stage('Approval') {
            when {
                allOf {
                    expression { params.ACTION == 'apply' }
                    expression { params.ENVIRONMENT == 'prod' }
                }
            }
            steps {
                timeout(time: 30, unit: 'MINUTES') {
                    input message: "Approve ${params.ACTION} to ${params.ENVIRONMENT}?",
                          ok: "Yes, proceed"
                }
            }
        }

        stage('Terraform Apply') {
            when {
                expression { params.ACTION == 'apply' }
            }
            steps {
                echo "Applying Terraform changes..."
                dir("${TF_DIR}") {
                    bat "terraform apply -auto-approve tfplan"
                }
            }
        }

        stage('Output Results') {
            when {
                expression { params.ACTION == 'apply' }
            }
            steps {
                echo "Fetching Terraform outputs..."
                dir("${TF_DIR}") {
                    bat "terraform output"
                }
            }
        }
    }

    post {
        success {
            echo "Pipeline completed successfully!"
        }
        failure {
            echo "Pipeline failed! Check logs above."
        }
        always {
            dir("${TF_DIR}") {
                bat "del /f /q tfplan 2>nul || exit 0"
            }
        }
    }
}
