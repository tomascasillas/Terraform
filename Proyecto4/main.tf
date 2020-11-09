provider "azurerm" {
    features {}
}

resource "azurerm_resource_group" "rg-terraform" {
    name = "RG-Terraform"
    location = "East US 2"
}

resource "azurerm_virtual_network" "red-virtual" {
    name = "VNet-Terraform"
    address_space = ["10.0.0.0/16"]
    location = "East US 2"
    resource_group_name = azurerm_resource_group.rg-terraform.name
}

resource "azurerm_subnet" "subnet-terraform" {
    name = "Subnet-Terraform"
    resource_group_name = azurerm_resource_group.rg-terraform.name
    virtual_network_name = azurerm_virtual_network.red-virtual.name
    address_prefixes = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "vm1-ip" {
    name = "VM1-ip"
    location = "East US 2"
    resource_group_name = azurerm_resource_group.rg-terraform.name
    allocation_method = "Dynamic"
}

resource "azurerm_network_security_group" "nsg-terraform" {
    name = "NSG-Terraform"
    location = "East US 2"
    resource_group_name = azurerm_resource_group.rg-terraform.name
    security_rule {
        name = "Puerto-SSH"
        priority = 150
        direction = "Inbound"
        access = "Allow"
        protocol = "TCP"
        source_address_prefix = "*"
        source_port_range = "*"
        destination_address_prefix = "*"
        destination_port_range = "22"
    }
}

resource "azurerm_network_interface" "nic-terraform" {
    name = "NIC-Terraform"
    location = "East US 2"
    resource_group_name = azurerm_resource_group.rg-terraform.name
    ip_configuration {
        name = "NIC-Configuration"
        private_ip_address_allocation = "Dynamic"
        subnet_id = azurerm_subnet.subnet-terraform.id
        public_ip_address_id = azurerm_public_ip.vm1-ip.id
    }   
}

resource "azurerm_network_interface_security_group_association" "nic-nsg" {
    network_interface_id = azurerm_network_interface.nic-terraform.id
    network_security_group_id = azurerm_network_security_group.nsg-terraform.id
}

resource "azurerm_linux_virtual_machine" "vm1" {
    name = "VM1"
    location = "East US 2"
    resource_group_name = azurerm_resource_group.rg-terraform.name
    network_interface_ids = [azurerm_network_interface.nic-terraform.id]
    size = "Standard_B1s"
    os_disk {
        name = "DiscoLinux"
        caching = "ReadWrite"
        storage_account_type = "Premium_LRS"
    }
    source_image_reference {
        publisher = "Canonical"
        offer = "UbuntuServer"
        sku = "16.04.0-LTS"
        version = "latest"
    }
    disable_password_authentication = false
    admin_username = "AzureUser"
    admin_password = "P4$$w0rd1234"
}