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
    container_name = "storedrum"
    key = "storedrum.tfstate"
  }
}

provider "azurerm" {
  features {

  }
}