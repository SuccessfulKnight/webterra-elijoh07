# Resource Group Name
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

# Location
variable "location" {
  description = "Azure region where the resources will be deployed"
  type        = string
}

# Admin Username
variable "admin_username" {
  description = "Admin username for the VM"
  type        = string
}

# Admin Password
variable "admin_password" {
  description = "Admin password for the VM"
  type        = string
}

# Network Interface IDs
variable "network_interface_ids" {
  description = "List of Network Interface IDs to attach to the VM"
  type        = list(string)
}

# VM Name
variable "vm_name" {
  description = "The name of the Virtual Machine"
  type        = string
}

# Provision Script Path
variable "provision_script_path" {
  description = "Path to the provisioning script to set up the VM"
  type        = string
}

# Jump Host Variables (for db2)
variable "db1_public_ip" {
  description = "The public IP address of DB1 server for jump host setup"
  type        = string
  default     = ""
}

variable "db2_private_ip" {
  description = "The private IP address of DB2 server"
  type        = string
  default     = ""
}

variable "provision_script_args" {
  description = "Arguments to pass to the provisioning script"
  type        = list(string)
  default     = []
}

# Variable for subnet_id
variable "subnet_id" {
  description = "Subnet ID for the VM"
  type        = string
  default     = null
}