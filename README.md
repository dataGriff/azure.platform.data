# Azure.Platform.Data

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
* Azure Databricks
* Azure Event Hub Namespace

## Useful Scripts

* [Azure Portal](https://portal.azure.com)
```bash
az login
az account set --subscription "%AZURE_SUBSCRIPTION%"
az account show
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
```

* [Terraform Cloud](https://app.terraform.io/app/organizations)
```bash
terraform login
```