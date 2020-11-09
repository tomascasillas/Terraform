resource "azurerm_virtual_machine_extension" "installNginx" {
  name = "installweb"
  publisher = "Microsoft.Azure.Extensions"
  type = "CustomScript"
  type_handler_version = "2.0"
  virtual_machine_id = azurerm_virtual_machine.VM-1.id

  settings = <<SETTINGS
  {
    "script": "${filebase64("nginx.sh")}"
  }
SETTINGS
}

resource "azurerm_virtual_machine_extension" "installweb_vm11" {
  name = "installweb"
  publisher = "Microsoft.Azure.Extensions"
  type = "CustomScript"
  type_handler_version = "2.0"
  virtual_machine_id = azurerm_virtual_machine.VM-1-2.id

  settings = <<SETTINGS
  {
    "script": "${filebase64("web.sh")}"
  }
SETTINGS
}

# Virtual Machine Extension to Install IIS
resource "azurerm_virtual_machine_extension" "installweb_vm2" {
  name = "installweb"
  publisher = "Microsoft.Compute"
  type = "CustomScriptExtension"
  type_handler_version = "1.9"
  virtual_machine_id = azurerm_virtual_machine.VM-2-1.id

  settings = <<SETTINGS
   { 
      "commandToExecute": "powershell Install-WindowsFeature -name Web-Server -IncludeManagementTools; Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled false"
   } 
SETTINGS
}
