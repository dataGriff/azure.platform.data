# Platform.Azure.Data

```file
azure.platform
│   README.md
|   .gitignore    
|   main.tf
|   outputs.tf
|   variables.tf
|   versions.tf
```
## Resources Deployed

* Azure Resource Group
* Azure Storage Account Data Lake Gen 2
* Azure Databricks (Standard)
* Azure Databricks (Premium)
* Azure Event Hub Namespace
* Azure Cosmos DB Serverless SQL API
* APIM Consumption

## Useful Scripts

* [Azure Portal](https://portal.azure.com)
```bash
az login
az account set --subscription "%AZURE_SUBSCRIPTION%"
az account show
```

```bash
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/%AZURE_SUBSCRIPTION_ID%" --name "aprg-lrn-cont"
```

```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply -auto-approve
```

```bash
terraform destroy
```

```bash
terraform plan -var "region=westeurope"
terraform apply -var "environment=development"
```

* [Terraform Cloud](https://app.terraform.io/app/organizations)
```bash
terraform login
```
