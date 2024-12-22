resource "azurerm_resource_group" "main" {
  name     = "elli-test1"
  location = var.location
  lifecycle {
    prevent_destroy = true
  }
}

module "network" {
  source              = "./network"
  resource_group_name = var.resource_group_name
  location            = var.location
}

module "load_balancer" {
  source              = "./loadbalancer"
  resource_group_name = var.resource_group_name
  location            = var.location

  subnet_id   = module.network.db_subnet_id
  db1_nic_id  = module.network.db1_nic_id
  db2_nic_id  = module.network.db2_nic_id
}

module "web_vm" {
  source                = "./vm"
  resource_group_name   = var.resource_group_name
  location              = var.location
  network_interface_ids = [module.network.web_nic_id]
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  vm_name               = "web-vm"
  provision_script_path = "./web.sh"
  provision_script_args = [module.load_balancer.lb_private_ip]
}

module "db_vm1" {
  source                = "./vm"
  resource_group_name   = var.resource_group_name
  location              = var.location
  network_interface_ids = [module.network.db1_nic_id]
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  vm_name               = "db1-vm"
  provision_script_path = "./db1.sh"
}

module "db_vm2" {
  source                = "./vm"
  resource_group_name   = var.resource_group_name
  location              = var.location
  network_interface_ids = [module.network.db2_nic_id]
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  vm_name               = "db2-vm"
  provision_script_path = "./db2.sh"
}