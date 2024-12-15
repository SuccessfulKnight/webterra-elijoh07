# Virtual Network
resource "azurerm_virtual_network" "main" {
  name                = "vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
}

# Subnet for Web
resource "azurerm_subnet" "web" {
  name                 = "web-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Subnet for Database
resource "azurerm_subnet" "db" {
  name                 = "db-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Public IP for Load Balancer
resource "azurerm_public_ip" "lb" {
  name                = "lb-public-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Public IP for Database NICs
resource "azurerm_public_ip" "db1" {
  name                = "db1-public-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Separate Public IP for Web NIC (to avoid conflict with Load Balancer)
resource "azurerm_public_ip" "web_nic" {
  name                = "web-nic-public-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Network Security Group for Web Subnet
resource "azurerm_network_security_group" "web_nsg" {
  name                = "web-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "all"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Network Security Group for Database Subnet
resource "azurerm_network_security_group" "db_nsg" {
  name                = "db-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "AllowPostgreSQL"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Associate Web Subnet with Web NSG
resource "azurerm_subnet_network_security_group_association" "web_subnet_nsg" {
  subnet_id                 = azurerm_subnet.web.id
  network_security_group_id = azurerm_network_security_group.web_nsg.id
}

# Associate Database Subnet with Database NSG
resource "azurerm_subnet_network_security_group_association" "db_subnet_nsg" {
  subnet_id                 = azurerm_subnet.db.id
  network_security_group_id = azurerm_network_security_group.db_nsg.id
}

# Network Interface for Web VM
resource "azurerm_network_interface" "web" {
  name                = "web"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "web-ip-config"
    subnet_id                     = azurerm_subnet.web.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.web_nic.id
  }
}

# Network Interface for Database VM1
resource "azurerm_network_interface" "db1" {
  name                = "db1-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "db1-ip-config"
    subnet_id                     = azurerm_subnet.db.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.db1.id
  }
}

# Network Interface for Database VM2
resource "azurerm_network_interface" "db2" {
  name                = "db2-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "db2-ip-config"
    subnet_id                     = azurerm_subnet.db.id
    private_ip_address_allocation = "Dynamic"
  }
}
