resource "azurerm_linux_virtual_machine" "vm" {
  count                 = 1
  name                  = "${var.vm_name}-${count.index}"
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = var.network_interface_ids
  size                  = "Standard_DS1_v2"

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18_04-daily-lts-gen2"
    version   = "latest"
  }

  disable_password_authentication = false
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "osdisk-${var.vm_name}-${count.index}"
  }

  # Connection block with conditional bastion_host for DB2
  connection {
    type     = "ssh"
    user     = var.admin_username
    password = var.admin_password
   host     = self.public_ip_address
  } 

  # Provisioner: Copy script file
  provisioner "file" {
    source      = var.provision_script_path
    destination = "/tmp/setup.sh"
  }

  # Provisioner: Execute script remotely
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/setup.sh",
      "sudo /tmp/setup.sh ${join(" ", var.provision_script_args)}"
    ]
  }
}
