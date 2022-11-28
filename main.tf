# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  backend "azurerm" {
    resource_group_name = "lk204_tf_rg_blobstr"
    storage_account_name = "tfstatestorageacnt"
    container_name = "tfstatecontainer"
    key = "terraform.tfstate"
  }
  required_version = ">= 1.1.0"
}

variable "imagebuild" {
  type        = string
  description = "Latest image build"
}


provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "lkaz204rg" {
  name     = "lkaz204-rg"
  location = "westus2"
}

resource "azurerm_container_group" "lkaz204acg" {
   name = "myappapi"
   location = azurerm_resource_group.lkaz204rg.location
   resource_group_name = azurerm_resource_group.lkaz204rg.name
   ip_address_type     = "Public"
   dns_name_label      = "lathishappapi"
   os_type             = "Linux"

   container {
    name   = "myappapi"
    image  = "lathishg/myapi:${var.imagebuild}"
    cpu    = "1"
    memory = "1"

    ports {
      port     = 80
      protocol = "TCP"
    }
  }
}