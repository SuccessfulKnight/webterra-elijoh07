output "lb_backend_pool_id" {
  value = azurerm_lb_backend_address_pool.main.id
}

output "lb_private_ip" {
  value = azurerm_lb.main.frontend_ip_configuration[0].private_ip_address
}