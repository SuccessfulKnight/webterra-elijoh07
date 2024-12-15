output "web_nic_id" {
  value = azurerm_network_interface.web.id
}

output "db1_nic_id" {
  value = azurerm_network_interface.db1.id
}

output "db2_nic_id" {
  value = azurerm_network_interface.db2.id
}

output "web_subnet_id" {
  value = azurerm_subnet.web.id
}

output "db_subnet_id" {
  value = azurerm_subnet.db.id
}

# Load Balancer Public IP
output "lb_public_ip_id" {
  description = "ID of the Public IP for the Load Balancer"
  value       = azurerm_public_ip.lb.id
}

# Output for Load Balancer Public IP Address (Optional, if needed)
output "lb_public_ip" {
  description = "Public IP address of the Load Balancer"
  value       = azurerm_public_ip.lb.ip_address
}

# Web VM Public IP
output "web_public_ip" {
  description = "Public IP address of the Web VM"
  value       = azurerm_public_ip.web_nic.ip_address
}

# Database VM Public IPs
output "db1_public_ip" {
  description = "Public IP address of Database VM1"
  value       = azurerm_public_ip.db1.ip_address
}

# Private IPs
output "web_private_ip" {
  description = "Private IP address of the Web VM"
  value       = azurerm_network_interface.web.ip_configuration[0].private_ip_address
}

output "db1_private_ip" {
  description = "Private IP address of Database VM1"
  value       = azurerm_network_interface.db1.ip_configuration[0].private_ip_address
}

output "db2_private_ip" {
  description = "Private IP address of Database VM2"
  value       = azurerm_network_interface.db2.ip_configuration[0].private_ip_address
}

