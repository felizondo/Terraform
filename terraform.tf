terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.97"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.48"
    }
       databricks = {
      source  = "databricks/databricks"
      version = "1.42.0"
    }
  }

  backend "azurerm" {
    resource_group_name   = "TerraformGroup"
    storage_account_name  = "felizondotfstorage"
    container_name        = "tfstate"
    key                   = "terraform.tfstate"
  }
}
