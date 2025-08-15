resource "azurerm_network_security_group" "nsg" {
    name                = "Naveennsg"
    location            = azurerm_resource_group.Naveenrg.location
    resource_group_name = azurerm_resource_group.Naveenrg.name
    security_rule {
        name                       = "AllowSSH"
        priority                   = 1000
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
  
}
resource "azurerm_network_interface_security_group_association" "nic_nsg" {
    network_interface_id      = azurerm_network_interface.nic.id
    network_security_group_id = azurerm_network_security_group.nsg.id
    depends_on = [azurerm_network_security_group.nsg]
  
}