
resource "azurerm_virtual_network" "red1" {
  name                = var.red1
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

}
resource "azurerm_virtual_network" "red2" {
  name                = var.red2
  address_space       = ["20.0.0.0/16"]
  location            = var.location2
  resource_group_name = azurerm_resource_group.rg2.name
}
resource "azurerm_subnet" "subnet1" {
  name                 = var.subnet1
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.red1.name
  address_prefix       = "10.0.1.0/24"
}
resource "azurerm_subnet" "subnet12" {
  name                 = var.subnet12
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.red1.name
  address_prefix       = "10.0.2.0/24"
}

resource "azurerm_subnet" "subnet2" {
  name                 = var.subnet2
  resource_group_name  = azurerm_resource_group.rg2.name
  virtual_network_name = azurerm_virtual_network.red2.name
  address_prefix       = "20.0.1.0/24"
}
resource "azurerm_public_ip" "vm-1-ip" {
  name                = "vm-1-ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
  sku                 = "Basic"
}
resource "azurerm_public_ip" "vm-1-2-ip" {
  name                = "vm-1-2-ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
  sku                 = "Basic"
}
resource "azurerm_public_ip" "vm-2-1-ip" {
  name                = "vm21ip"
  location            = var.location2
  resource_group_name = azurerm_resource_group.rg2.name
  allocation_method   = "Dynamic"
  sku                 = "Basic"
}
resource "azurerm_network_interface" "vm-1-nic" {
  name                = "vm-1-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm-1-ip.id
  }
}
resource "azurerm_network_interface" "vm-1-2-nic" {
  name                = "vm-1-2-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet12.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm-1-2-ip.id
  }
}
resource "azurerm_network_interface" "vm-2-1-nic" {
  name                = "vm-2-1-nic"
  location            = var.location2
  resource_group_name = azurerm_resource_group.rg2.name

  ip_configuration {
    name                          = "ipconfig2"
    subnet_id                     = azurerm_subnet.subnet2.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm-2-1-ip.id
  }
}
resource "azurerm_network_security_group" "NSG1" {
  name                = "NSG-${var.escritorioclase}-1"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}


resource "azurerm_network_security_group" "NSG2" {
  name                = "NSG-${var.escritorioclase}-2"
  location            = var.location2
  resource_group_name = azurerm_resource_group.rg2.name
}
resource "azurerm_virtual_network_peering" "red1" {
  name                      = "vnet1_a_vnet2"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.red1.name
  remote_virtual_network_id = azurerm_virtual_network.red2.id
}
resource "azurerm_virtual_network_peering" "red2" {
  name                      = "vnet2_a_vnet1"
  resource_group_name       = azurerm_resource_group.rg2.name
  virtual_network_name      = azurerm_virtual_network.red2.name
  remote_virtual_network_id = azurerm_virtual_network.red1.id
}
#NSG1
resource "azurerm_network_security_rule" "NSG-SSH" {
  access                      = "Allow"
  direction                   = "Inbound"
  name                        = "SSH"
  network_security_group_name = azurerm_network_security_group.NSG1.name
  priority                    = 100
  protocol                    = "Tcp"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  source_port_range           = "*"
}
resource "azurerm_network_security_rule" "NSG-WEB" {
  access                      = "Allow"
  direction                   = "Inbound"
  name                        = "WEB"
  network_security_group_name = azurerm_network_security_group.NSG1.name
  priority                    = 101
  protocol                    = "Tcp"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  source_port_range           = "*"
}
#NSG2
resource "azurerm_network_security_rule" "NSG-2RDP" {
  access                      = "Allow"
  direction                   = "Inbound"
  name                        = "RDP"
  network_security_group_name = azurerm_network_security_group.NSG2.name
  priority                    = 100
  protocol                    = "Tcp"
  destination_port_range      = "3389"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg2.name
  source_port_range           = "*"
}
resource "azurerm_network_security_rule" "NSG-2WEB" {
  access                      = "Allow"
  direction                   = "Inbound"
  name                        = "WEB"
  network_security_group_name = azurerm_network_security_group.NSG2.name
  priority                    = 101
  protocol                    = "Tcp"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg2.name
  source_port_range           = "*"
}