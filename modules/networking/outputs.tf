output "my_vnet" {
  value = azurerm_virtual_network.myVnet.id
}

output "my_subnet" {
  value = azurerm_subnet.mySubnet.id
}

output "my_subneprivate" {
  value = azurerm_subnet.private_subnet.id
}


output "name_subnet" {
  value = azurerm_subnet.mySubnet.name
}

output "name_subneprivate" {
  value = azurerm_subnet.private_subnet.name
}

output "nsg_mysubnet" {
  value = azurerm_subnet_network_security_group_association.my_subnet_nsg_association.id
}

output "nsg_mysubneprivate" {
  value = azurerm_subnet_network_security_group_association.my_subnet_nsg_privateassociation.id
}