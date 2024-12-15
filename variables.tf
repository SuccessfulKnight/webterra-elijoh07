variable "admin_username" {
  type    = string
  default = "azureadmin"
}
variable "admin_password" {
  type        = string
  description = "The password for the local account that will be created on the new VM."
  default     = "CiAdm@1234"
}

variable "resource_group_name_prefix" {
  type        = string
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
  default     = "rg"
}

variable "location" {
  description = "The Azure region to deploy resources in."
  default     = "westeurope"
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "elli-test1" # Default value to avoid being prompted
}

variable "provision_script_path" {
  description = "Path to the provisioning script"
  type        = string
  default     = "./default.sh"
}

variable "provision_script_args" {
  description = "Arguments to pass to the provisioning script"
  type        = list(string)
  default     = []
}

# Add subnet_id
variable "subnet_id" {
  description = "Subnet ID for the VM"
  type        = string
  default     = null
}
