provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.rg1
  location = var.location
}
resource "azurerm_resource_group" "rg2" {
  name     = var.rg2
  location = var.location2
}

resource "azurerm_virtual_machine" "VM-1" {
  location              = var.location
  name                  = "VM-1"
  network_interface_ids = [azurerm_network_interface.vm-1-nic.id]
  resource_group_name   = azurerm_resource_group.rg.name
  vm_size               = "Standard_B1s"
  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    create_option     = "FromImage"
    name              = "VM-1-OS"
    managed_disk_type = "Standard_LRS"
    caching           = "ReadWrite"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  os_profile {
    admin_username = var.usuario
    admin_password = var.password
    computer_name  = "VM-1"
  }
  boot_diagnostics {
    enabled     = false
    storage_uri = ""
  }
}

resource "azurerm_virtual_machine" "VM-1-2" {
  name                  = "VM-1-2"
  location              = var.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.vm-1-2-nic.id]
  vm_size               = "Standard_B1s"
  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    create_option     = "FromImage"
    name              = "VM-1-2-OS"
    managed_disk_type = "Standard_LRS"
    caching           = "ReadWrite"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  os_profile {
    admin_username = var.usuario
    admin_password = var.password
    computer_name  = "VM-1-2"
  }
  boot_diagnostics {
    enabled     = false
    storage_uri = ""
  }
}

resource "azurerm_virtual_machine" "VM-2-1" {
  name                  = "VM-2-1"
  location              = azurerm_resource_group.rg2.location
  resource_group_name   = azurerm_resource_group.rg2.name
  network_interface_ids = [azurerm_network_interface.vm-2-1-nic.id]
  vm_size               = "Standard_B2s"
  storage_image_reference {
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
  os_profile_windows_config {
    provision_vm_agent        = true
    enable_automatic_upgrades = true
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
