resource "azurerm_storage_account" "storage_account" {
  name                     = "storagedatabricks"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  is_hns_enabled           = true # Habilita el almacenamiento de archivos de Hadoop / Habilitar Gen2
  account_kind             = "StorageV2"
  enable_https_traffic_only = true

  blob_properties {
    delete_retention_policy {
      days = 7
    }
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_storage_container" "storage_container" {
  name                  = "vmlogs"
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "private"
}