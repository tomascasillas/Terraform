
# Define the common tags for all resources.
variable "tags" {
  description = "A map of the tags to use for the resources that are deployed."
  type        = "map"

  default = {
    name                  = "HighCharity Infra"
    tier                  = "Infrastructure"
    application           = "HighCharity"
    applicationversion    = "1.0.0"
    environment           = "Sandbox"
    infrastructureversion = "1.0.0"
    projectcostcenter     = "0570025003"
    operatingcostcenter   = "0570025003"
    owner                 = "fireteamosiris@somedomain.com"
    securitycontact       = "fireteamosiris@somedomain.com"
    confidentiality       = "PII/PHI"
    compliance            = "HIPAA"
  }
}

# Define prefix for consistent resource naming.
variable "resource_prefix" {
  type        = "string"
  default     = "zeushighcharity"
  description = "Service prefix to use for naming of resources."
}

# Define Azure region for resource placement.
variable "location" {
  type        = "string"
  default     = "westus"
  description = "Azure region for deployment of resources."
}

# Define username for use on the hosts.
variable "username" {
  type        = "string"
  default     = "fireteamosiris"
  description = "Username to build and use on the VM hosts."
}

variable "password" {
  type    = string
  default = "P4$$w0rd12345"
}

variable "usuario" {
  type    = string
  default = "usuario"
}