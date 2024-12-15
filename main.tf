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

  public_ip_address_id = module.network.lb_public_ip_id # Pass the public IP ID
  db1_nic_id           = module.network.db1_nic_id      # Pass Database VM1 NIC ID
  db2_nic_id           = module.network.db2_nic_id      # Pass Database VM2 NIC ID
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
  provision_script_args = [module.load_balancer.lb_public_ip] # Pass Load Balancer IP dynamically
}

module "db_vm1" {
  source                = "./vm"
  resource_group_name   = var.resource_group_name
  location              = var.location
  network_interface_ids = [module.network.db1_nic_id]
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  vm_name               = "db1-vm"
  provision_script_path = "./db.sh"
}

module "db_vm2" {
  source                = "./vm"
  resource_group_name   = var.resource_group_name
  location              = var.location
  network_interface_ids = [module.network.db2_nic_id]
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  vm_name               = "db2-vm"
  provision_script_path = "./db.sh"
  db1_public_ip         = module.network.db1_public_ip # Pass DB1 Public IP as jump host
  db2_private_ip        = module.network.db2_private_ip # Pass DB2 Private IP
}