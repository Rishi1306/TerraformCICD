terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.73.0"
    }
  }
  backend "azurerm" {
    resource_group_name = "rike-rg-1"
    storage_account_name = "rikestorage13"
    container_name = "pipedrum"
    key = "pipedrum.tfstate"
  }
}

provider "azurerm" {
  features {
  }
  subscription_id = "5b9f49a3-8bda-49fa-88c0-baf31ef2f4f3"
}