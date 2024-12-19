variable "resource_group_name" {
  type = string
}

variable "name_vm" {
  type = string
}

variable "nameinterface_vm" {
  type = string
}

variable "location" {
  type = string
}

variable "admin_username" {
  type = string
}

variable "ssh_public_key" {
  type = string
}

variable "instance_count" {
  type = string
  default = "0"
}

variable "subnet_id" {
  type = string
  default = ""
}

variable "subnet_publicVM" {
  type = string
  default = ""
}

variable "vm_size" {
  type = string
  default = "Standard_DS1_v2"
}


variable "public_ip" {
  type = string
  default = ""
}