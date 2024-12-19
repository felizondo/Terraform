/*resource "azurerm_resource_group" "myRg" {
  name     = "miGruopDeResource"
  location = var.location
}*/


resource "azurerm_virtual_network" "myVnet" {
  name                = "miVnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.groupname
}

resource "azurerm_subnet" "mySubnet" {
  name                 = "miSubnet"
  resource_group_name  = var.groupname
  virtual_network_name = azurerm_virtual_network.myVnet.name
  address_prefixes     = ["10.0.1.0/24"]

  delegation {
    name = "databricksDelegation"
    service_delegation {
      name = "Microsoft.Databricks/workspaces"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/action"
      ]
    }
  }  
}

resource "azurerm_subnet" "private_subnet" {
  name                 = "miSubnetprivate"
  resource_group_name  = var.groupname
  virtual_network_name = azurerm_virtual_network.myVnet.name
  address_prefixes     = ["10.0.2.0/24"]

  delegation {
    name = "databricksDelegation"
    service_delegation {
      name = "Microsoft.Databricks/workspaces"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/action"
      ]
    }
  }
}


resource "azurerm_network_security_group" "my_nsg" {
  name                = "myNSG"
  location            = var.location
  resource_group_name = var.groupname

  // Permitir el tráfico saliente a internet
  security_rule {
    name                       = "allow-outbound-internet"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "Internet"
  }

  // Permitir el tráfico SSH entrante desde cualquier lugar
  security_rule {
    name                       = "allow-ssh-inbound"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  // Permitir toda comunicación interna dentro de la VNet
  security_rule {
    name                       = "allow-internal-vnet"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }

  // Reglas específicas requeridas por Network Intent Policy
  security_rule {
    name                       = "databricks-worker-to-databricks-webapp"
    priority                   = 110
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "AzureDatabricks"
  }

  security_rule {
    name                       = "databricks-worker-to-sql"
    priority                   = 120
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3306"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "Sql"
  }

  security_rule {
    name                       = "databricks-worker-to-storage"
    priority                   = 130
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "Storage"
  }

  security_rule {
    name                       = "databricks-worker-to-eventhub"
    priority                   = 140
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "9093"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "EventHub"
  }

  security_rule {
    name                       = "databricks-control-plane-to-worker-proxy"
    priority                   = 150
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5557"
    source_address_prefix      = "AzureDatabricks"
    destination_address_prefix = "VirtualNetwork"
  }
}

resource "azurerm_subnet_network_security_group_association" "my_subnet_nsg_association" {
  subnet_id                 = azurerm_subnet.mySubnet.id
  network_security_group_id = azurerm_network_security_group.my_nsg.id
}

resource "azurerm_subnet_network_security_group_association" "my_subnet_nsg_privateassociation" {
  subnet_id                 = azurerm_subnet.private_subnet.id
  network_security_group_id = azurerm_network_security_group.my_nsg.id
}