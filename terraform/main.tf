#create 3 vm on azure

# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

#create resource myweb
resource "azurerm_resource_group" "myweb" {
  name     = "myweb"
  location = "Japan East"
}

#create myweb-vm1-Vnet
resource "azurerm_virtual_network" "myweb-vm1-Vnet" {
  name                = "myweb-vm-1-Vnet"
  address_space       = ["10.0.0.0/24"]
  location            = azurerm_resource_group.myweb.location
  resource_group_name = azurerm_resource_group.myweb.name
}

#creating subnet on myweb-vm1-Vnet
resource "azurerm_subnet" "myweb-vm1-subnet" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.myweb.name
  virtual_network_name = azurerm_virtual_network.myweb-vm1-Vnet.name
  address_prefixes     = ["10.0.0.0/24"]
}

#create public ip on myweb-vm1-Vnet
resource "azurerm_public_ip" "myweb-vm-1-public-ip" {
  name                = "myweb-public-ip-1-Vnet"
  resource_group_name = azurerm_resource_group.myweb.name
  location            = azurerm_resource_group.myweb.location
  allocation_method   = "Static"

  tags = {
    environment = "Dev"
  }
}

#create network card on myweb-vm1-Vnet
resource "azurerm_network_interface" "myweb-vm-1-nic" {
  name                = "myweb-vm-1-nic"
  location            = azurerm_resource_group.myweb.location
  resource_group_name = azurerm_resource_group.myweb.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.myweb-vm1-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.myweb-vm-1-public-ip.id
  }
}

#create security group on myweb-vm1-Vnet
resource "azurerm_network_security_group" "myweb-vm-1-sg" {
  name                = "myweb-vm-1-sg"
  location            = azurerm_resource_group.myweb.location
  resource_group_name = azurerm_resource_group.myweb.name

  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Dev"
  }
}

#associate NSG and subnet on myweb-vm1-Vnet
resource "azurerm_subnet_network_security_group_association" "associate-nsg-vm1-subnet" {
  subnet_id                 = azurerm_subnet.myweb-vm1-subnet.id
  network_security_group_id = azurerm_network_security_group.myweb-vm-1-sg.id
}

#create linux virtual machine for myweb-vm1-Vnet
resource "azurerm_linux_virtual_machine" "myweb-vm-1" {
  name                = "myweb-vm-1"
  resource_group_name = azurerm_resource_group.myweb.name
  location            = azurerm_resource_group.myweb.location
  size                = "Standard_B1s"
  admin_username      = "rastarure"
  admin_password      = "Azayaore08376"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.myweb-vm-1-nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

output "myweb-vm-1-ip" {
     description = "The myweb-vm-1 IP is:"
     value = azurerm_public_ip.myweb-vm-1-public-ip.ip_address
 } 

#-------------------------------------------------------------------------

#create myweb-vm2-Vnet
resource "azurerm_virtual_network" "myweb-vm2-Vnet" {
  name                = "myweb-vm-2-Vnet"
  address_space       = ["10.0.1.0/24"]
  location            = azurerm_resource_group.myweb.location
  resource_group_name = azurerm_resource_group.myweb.name
}

#creating subnet on myweb-vm2-Vnet
resource "azurerm_subnet" "myweb-vm2-subnet" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.myweb.name
  virtual_network_name = azurerm_virtual_network.myweb-vm2-Vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

#create public ip on myweb-vm2-Vnet
resource "azurerm_public_ip" "myweb-vm-2-public-ip" {
  name                = "myweb-public-ip-2-Vnet"
  resource_group_name = azurerm_resource_group.myweb.name
  location            = azurerm_resource_group.myweb.location
  allocation_method   = "Static"

  tags = {
    environment = "Dev"
  }
}

#create network card on myweb-vm2-Vnet
resource "azurerm_network_interface" "myweb-vm-2-nic" {
  name                = "myweb-vm-2-nic"
  location            = azurerm_resource_group.myweb.location
  resource_group_name = azurerm_resource_group.myweb.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.myweb-vm2-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.myweb-vm-2-public-ip.id
  }
}

#create security group on myweb-vm2-Vnet
resource "azurerm_network_security_group" "myweb-vm-2-sg" {
  name                = "myweb-vm-2-sg"
  location            = azurerm_resource_group.myweb.location
  resource_group_name = azurerm_resource_group.myweb.name

  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Dev"
  }
}

#associate NSG and subnet on myweb-vm2-Vnet
resource "azurerm_subnet_network_security_group_association" "associate-nsg-vm2-subnet" {
  subnet_id                 = azurerm_subnet.myweb-vm2-subnet.id
  network_security_group_id = azurerm_network_security_group.myweb-vm-2-sg.id
}

#create linux virtual machine for myweb-vm2-Vnet
resource "azurerm_linux_virtual_machine" "myweb-vm-2" {
  name                = "myweb-vm-2"
  resource_group_name = azurerm_resource_group.myweb.name
  location            = azurerm_resource_group.myweb.location
  size                = "Standard_B1s"
  admin_username      = "rastarure"
  admin_password      = "Azayaore08376"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.myweb-vm-2-nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

output "myweb-vm-2-ip" {
     description = "The myweb-vm-2 IP is:"
     value = azurerm_public_ip.myweb-vm-2-public-ip.ip_address
 } 

#------------------------------------------------------------------------

#create resource gitlab-runner
resource "azurerm_resource_group" "gitlab-runner" {
  name     = "gitlab-runner"
  location = "Japan East"
}

#create gitlab-runner-Vnet
resource "azurerm_virtual_network" "gitlab-runner-Vnet" {
  name                = "gitlab-runner-Vnet"
  address_space       = ["10.0.0.0/24"]
  location            = azurerm_resource_group.gitlab-runner.location
  resource_group_name = azurerm_resource_group.gitlab-runner.name
}

#creating subnet on gitlab-runner-Vnet
resource "azurerm_subnet" "gitlab-runner-subnet" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.gitlab-runner.name
  virtual_network_name = azurerm_virtual_network.gitlab-runner-Vnet.name
  address_prefixes     = ["10.0.0.0/24"]
}

#create public ip on gitlab-runner-Vnet
resource "azurerm_public_ip" "gitlab-runner-public-ip" {
  name                = "gitlab-runner-public-ip"
  resource_group_name = azurerm_resource_group.gitlab-runner.name
  location            = azurerm_resource_group.gitlab-runner.location
  allocation_method   = "Static"

  tags = {
    environment = "Dev"
  }
}

#create network card on gitlab-runner-Vnet
resource "azurerm_network_interface" "gitlab-runner-nic" {
  name                = "myweb-vm-2-nic"
  location            = azurerm_resource_group.gitlab-runner.location
  resource_group_name = azurerm_resource_group.gitlab-runner.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.gitlab-runner-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.gitlab-runner-public-ip.id
  }
}

#create security group on gitlab-runner-Vnet
resource "azurerm_network_security_group" "gitlab-runner-sg" {
  name                = "gitlab-runner-sg"
  location            = azurerm_resource_group.gitlab-runner.location
  resource_group_name = azurerm_resource_group.gitlab-runner.name

  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Dev"
  }
}

#associate NSG and subnet on gitlab-runner-Vnet
resource "azurerm_subnet_network_security_group_association" "associate-nsg-subnet" {
  subnet_id                 = azurerm_subnet.gitlab-runner-subnet.id
  network_security_group_id = azurerm_network_security_group.gitlab-runner-sg.id
}

#create linux virtual machine for gitlab-runner-Vnet
resource "azurerm_linux_virtual_machine" "gitlab-runner-vm-1" {
  name                = "gitlab-runner-vm-1"
  resource_group_name = azurerm_resource_group.gitlab-runner.name
  location            = azurerm_resource_group.gitlab-runner.location
  size                = "Standard_B1s"
  admin_username      = "rastarure"
  admin_password      = "Azayaore08376"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.gitlab-runner-nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

output "gitlab-runner-vm-ip" {
     description = "gitlab-runner-vm-ip is:"
     value = azurerm_public_ip.gitlab-runner-public-ip.ip_address
 }
