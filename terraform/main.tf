terraform {
  backend "azurerm" {
    resource_group_name  = "terraform-agrzv-rg"
    storage_account_name = "terraformagrzvsa"
    container_name       = "dev-tfstate"
    key                  = "dev/terraform.tfstate"
  }
}

provider "azurerm" {
  # The "feature" block is required for AzureRM provider 2.x.
  # If you're using version 1.x, the "features" block is not allowed.
  #version = "~>2.0"
  features {}
}

data "azurerm_client_config" "current" {}

#Create Resource Group
resource "azurerm_resource_group" "resource_group" {
  name     = var.resource_group_name
  location = var.location
}

#Create Virtual Network
resource "azurerm_virtual_network" "virtual_network" {
  name                = var.virtual_network_name
  address_space       = ["192.168.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name
}

# Create Subnet
resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = ["192.168.0.0/24"]
}

