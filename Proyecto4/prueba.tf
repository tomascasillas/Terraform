provider "azurerm" {
    features {}
}

resource "azurerm_windows_virtual_machine" "example" {
  name                = "example-vm"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = "Standard_F2"
  admin_username      = var.admin
  admin_password      = var.adminPassword
  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  identity {
    type = "SystemAssigned"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_virtual_machine" "VM-2-1" {
  name                  = "VM-2-1"
  location              = azurerm_resource_group.rg2.location
  resource_group_name   = azurerm_resource_group.rg2.name
  network_interface_ids = [azurerm_network_interface.vm-2-1-nic.id]
  vm_size               = "Standard_B2s"

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
  storage_os_disk {
    name              = "VM-2-1-OS"
    managed_disk_type = "Standard_LRS"
    caching           = "ReadWrite"
    create_option     = "FromImage"
  }
  os_profile {
    admin_username = var.usuario
    admin_password = var.password
    computer_name  = "VM-2-1"
  }
  boot_diagnostics {
    enabled     = false
    storage_uri = ""
  }

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



resource "azurerm_virtual_machine_extension" "example" {
  name                 = "hostname"
  virtual_machine_id   = azurerm_virtual_machine.example.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
    {
        "commandToExecute":
        "sudo apt update
        sudo apt-get -y install apache2
        echo "<H1>Pagina creada mediante script</H1>" > /var/www/html/index.html"
    }
SETTINGS


  tags = {
    environment = "Production"
  }
}