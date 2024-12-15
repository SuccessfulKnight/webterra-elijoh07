# Load Balancer Public IP
output "loadbalancer_ip" {
  description = "Public IP address of the Load Balancer"
  value       = module.network.lb_public_ip
}

# VM Public IPs
output "web_public_ips" {
  description = "Public IP addresses of the Virtual Machines"
  value = [
    module.network.web_public_ip # web VM
  ]
}

output "db1_public_ips" {
  description = "Public IP addresses of the Virtual Machines"
  value = [
    module.network.db1_public_ip # DB1 VM
  ]
}

# VNet Private IPs
output "web_local_ips" {
  description = "Private IP addresses of the Virtual Machines"
  value = [
    module.network.web_private_ip # Web VM
  ]
}
output "db1_local_ips" {
  description = "Private IP addresses of the Virtual Machines"
  value = [
    module.network.db1_private_ip # DB1 VM
  ]
}
output "db2_local_ips" {
  description = "Private IP addresses of the Virtual Machines"
  value = [
    module.network.db2_private_ip # DB2 VM
  ]
}
