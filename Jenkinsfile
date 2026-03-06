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
