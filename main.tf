provider "azurerm" {
  features {}  
  skip_provider_registration = true
}


module "networking" {
  source              = "./modules/networking"
  groupname           = var.group_name
  location            = var.locations
}

module "storage" {
  source = "./modules/storage"
  resource_group_name = var.group_name
  location = var.locations
}

module "Databric" {
  source              = "./modules/databricks"
  resource_group_name = var.group_name
  location            = var.locations
  vnet                = module.networking.my_vnet
  subnet              = module.networking.name_subnet
  subnet_private      = module.networking.name_subneprivate
  nsg_mysubnet        = module.networking.nsg_mysubnet
  nsg_mysubneprivate  = module.networking.nsg_mysubneprivate
}

/*
module "VM1" {
  source               = "./modules/vm"
  name_vm              = "VMCVH1"
  nameinterface_vm     = "InterfaceVM1"
  resource_group_name  = module.networking.group_name
  location             = var.locations
  admin_username       = "adminuser"
  ssh_public_key       = "ssh-rsa ..."
  public_ip            = "myPublicIP1"
  subnet_id            = module.networking.my_subnet 
}

module "VM2" {
  source               = "./modules/vm"
  name_vm              = "VMCVH2"
  nameinterface_vm     = "InterfaceVM2"
  resource_group_name  = module.networking.group_name
  location             = var.locations
  admin_username       = "adminuser"
  ssh_public_key       = "ssh-rsa ..."
  public_ip            = "myPublicIP2"
  subnet_id            = module.networking.my_subnet 
}
*/
