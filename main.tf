provider "azurerm" {
  features {}

}

backend "azurerm" {

}

resource "azurerm_resource_group" "Naveenrg" {
  name     = var.resourcegroupname
  location = var.locationname

}

resource "azurerm_virtual_network" "vnet" {
    name                = "Naveenvnet"
    address_space       = ["10.0.0.0/16"]
    resource_group_name = azurerm_resource_group.Naveenrg.name
    location            = azurerm_resource_group.Naveenrg.location
    depends_on = [ azurerm_resource_group.Naveenrg ]
  
}

resource "azurerm_subnet" "subnet1" {
    name                 = "Naveensubnet"
    resource_group_name  = azurerm_resource_group.Naveenrg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes     = ["10.0.1.0/24"]
    depends_on = [ azurerm_virtual_network.vnet ]
  
}
resource "azurerm_public_ip" "azurerm_public_ip" {
    name                = "Naveenpublicip"
    location            = azurerm_resource_group.Naveenrg.location
    resource_group_name = azurerm_resource_group.Naveenrg.name
    allocation_method   = "Static"
    depends_on = [ azurerm_subnet.subnet1 ]
  
}
resource "azurerm_network_interface" "nic" {
    name                = "Naveennic"
    location            = azurerm_resource_group.Naveenrg.location
    resource_group_name = azurerm_resource_group.Naveenrg.name
  
    ip_configuration {
        name                          = "internal"
        subnet_id                     = azurerm_subnet.subnet1.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.azurerm_public_ip.id
        
    }
    depends_on = [ azurerm_public_ip.azurerm_public_ip ]
}

resource "azurerm_virtual_machine" "vm1" {
    name                  = "Naveenvm"
    location              = azurerm_resource_group.Naveenrg.location
    resource_group_name   = azurerm_resource_group.Naveenrg.name
    network_interface_ids = [azurerm_network_interface.nic.id]
    vm_size               = "Standard_D2s_v3"

    storage_os_disk {
        name              = "Naveenosdisk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }

    storage_image_reference {
        publisher = "Canonical"
        offer     = "0001-com-ubuntu-server-jammy"
        sku       = "22_04-lts-gen2"
        version   = "latest"
    }

    os_profile {
        computer_name  = "NaveenVM"
        admin_username = "vm1"
        admin_password = "123123123a@A"
    }

    os_profile_linux_config {
        disable_password_authentication = false
    }
depends_on = [ azurerm_network_interface.nic  ]
}
output "name" {
  value = azurerm_virtual_machine.vm1.name

  
}
output "location" {
  value = azurerm_virtual_machine.vm1.location
}   
output "public_ip_address_id" {
  value = azurerm_public_ip.azurerm_public_ip.id
  
}
output "public_ip_address" {
  value = azurerm_public_ip.azurerm_public_ip.ip_address
}

