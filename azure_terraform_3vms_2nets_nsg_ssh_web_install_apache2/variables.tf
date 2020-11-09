variable "location" {
  type    = string
  default = "eastus2"
}
variable "escritorioclase" {
  type    = string
  default = "t38w10"
}
variable "location2" {
  type    = string
  default = "northeurope"
}
variable "rg1" {
  type    = string
  default = "RG-VNet1"
}
variable "rg2" {
  type    = string
  default = "RG-VNet2"
}
variable "red1" {
  type    = string
  default = "Vnet-1"
}
variable "red2" {
  type    = string
  default = "Vnet-2"
}
variable "subnet1" {
  type    = string
  default = "Subnet1-1"
}
variable "subnet12" {
  type    = string
  default = "Subnet1-2"
}
variable "subnet2" {
  type    = string
  default = "Subnet2-1"
}
variable "password" {
  type    = string
  default = "P4$$w0rd12345"
}
variable "ssh-source-address" {
  type    = string
  default = "*"
}
variable "usuario" {
  type    = string
  default = "usuario"
}