variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "public_ip_address_id" {
  description = "ID of the public IP address for the Load Balancer"
  type        = string
}

variable "db1_nic_id" {
  description = "ID of the network interface for DB1"
  type        = string
}

variable "db2_nic_id" {
  description = "ID of the network interface for DB2"
  type        = string
}
