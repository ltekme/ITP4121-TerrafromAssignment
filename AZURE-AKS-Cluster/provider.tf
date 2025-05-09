provider "azurerm" {
  subscription_id = var.SUB_ID
  features {
    key_vault {
      purge_soft_delete_on_destroy = false
    }
  }
}
provider "azuread" {
}