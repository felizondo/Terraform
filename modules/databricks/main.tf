resource "azurerm_databricks_workspace" "myDatabricks" {
  name                = "miDatabricks"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "standard"

  custom_parameters {
    virtual_network_id = var.vnet
    public_subnet_name = var.subnet
    private_subnet_name = var.subnet_private
    public_subnet_network_security_group_association_id = var.nsg_mysubnet
    private_subnet_network_security_group_association_id = var.nsg_mysubneprivate
    #storage_account_name = var.storage
  }
}