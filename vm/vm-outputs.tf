output "vm_names" {
  value = [for vm in azurerm_linux_virtual_machine.vm : vm.name]
}

output "vm_public_ips" {
  value = var.network_interface_ids
}
