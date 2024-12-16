# Load Balancer
resource "azurerm_lb" "main" {
  name                = "db-loadbalancer"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                          = "frontend"
    private_ip_address_allocation = "Dynamic" # or "Static"
    subnet_id                     = var.subnet_id
  }
}
# Backend Address Pool
resource "azurerm_lb_backend_address_pool" "main" {
  name            = "db-backend-pool"
  loadbalancer_id = azurerm_lb.main.id
}

# Load Balancer Health Probe
resource "azurerm_lb_probe" "main" {
  name            = "db-health-probe"
  loadbalancer_id = azurerm_lb.main.id
  protocol        = "Tcp"
  port            = 5432
}

# Load Balancer Rule
resource "azurerm_lb_rule" "main" {
  name                           = "db-lb-rule"
  loadbalancer_id                = azurerm_lb.main.id
  protocol                       = "Tcp"
  frontend_port                  = 5432
  backend_port                   = 5432
  frontend_ip_configuration_name = "frontend"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.main.id]
  probe_id                       = azurerm_lb_probe.main.id
}

# Backend Address Pool Association for DB1 VM NIC
resource "azurerm_network_interface_backend_address_pool_association" "db1" {
  network_interface_id    = var.db1_nic_id
  backend_address_pool_id = azurerm_lb_backend_address_pool.main.id
  ip_configuration_name   = "db1-ip-config"
}

resource "azurerm_network_interface_backend_address_pool_association" "db2" {
  network_interface_id    = var.db2_nic_id
  backend_address_pool_id = azurerm_lb_backend_address_pool.main.id
  ip_configuration_name   = "db2-ip-config"
}
