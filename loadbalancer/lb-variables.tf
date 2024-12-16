variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "db1_nic_id" {
  type = string
}

variable "db2_nic_id" {
  type = string
}

variable "subnet_id" {
  type = string
}
