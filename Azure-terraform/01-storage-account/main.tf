# 1. Configure the Terraform settings and required providers
terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0" # Targets the major 4.x release line
    }
  }
}

# 2. Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

# 3. Create a Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "rg-storage-prod-001"
  location = "East US"
}

# 4. Create the Storage Account
resource "azurerm_storage_account" "storage" {
  name                     = "stproddataunique001" # Must be globally unique, 3-24 characters, numbers and lowercase letters only
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS" # Locally Redundant Storage

  # Security Best Practices
  enable_https_traffic_only       = true
  min_tls_version                 = "TLS1_2"
  public_network_access_enabled   = true
  allow_nested_items_to_be_public = false

  tags = {
    Environment = "Production"
    ManagedBy   = "Terraform"
  }
}

# 5. Optional: Create a Blob Storage Container inside the account
resource "azurerm_storage_container" "container" {
  name                  = "data-payloads"
  storage_account_id    = azurerm_storage_account.storage.id
  container_access_type = "private"
}