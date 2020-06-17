resource "azurerm_virtual_network" "workload_vnet" {
  name                = "workload_vnet"
  location            = var.LOCATION
  resource_group_name = var.RESOURCE_GROUP_NAME
  address_space       = ["${var.WORKLOAD_VNET_ADDRESS_SPACE}"]
}

resource "azurerm_subnet" "wl_default_subnet" {
  name                 = "default"
  resource_group_name  = var.RESOURCE_GROUP_NAME
  virtual_network_name = azurerm_virtual_network.workload_vnet.name
  address_prefixes       = [var.WORKLOAD_DEFAULT_SUBNET_ADDRESS_PREFIX]
  service_endpoints      = ["Microsoft.Web"]
}

resource "azurerm_subnet" "wl_gateway_subnet" {
  name                   = "gateway"
  resource_group_name    = var.RESOURCE_GROUP_NAME
  virtual_network_name   = azurerm_virtual_network.workload_vnet.name
  address_prefixes       = [var.WORKLOAD_GATEWAY_SUBNET_ADDRESS_PREFIX]
  service_endpoints      = ["Microsoft.Web"]
}

resource "azurerm_subnet" "wl_webapp_subnet" {
  name                 = "websubnet"
  resource_group_name  = var.RESOURCE_GROUP_NAME
  virtual_network_name = azurerm_virtual_network.workload_vnet.name
  address_prefixes       = [var.WORKLOAD_WEBAPP_SUBNET_ADDRESS_PREFIX]

  delegation {
     name = "appservicedelegation"

     service_delegation {
       name    = "Microsoft.Web/serverFarms"
       actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
     }
   }
}

resource "azurerm_subnet" "wl_bastion_subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = var.RESOURCE_GROUP_NAME
  virtual_network_name = azurerm_virtual_network.workload_vnet.name
  address_prefixes       = [var.WORKLOAD_BASTION_SUBNET_ADDRESS_PREFIX]
}


resource "azurerm_route_table" "routetofirewall" {
  name                          = "forceOutBoundToFirewall"
  location                      = var.LOCATION
  resource_group_name           = var.RESOURCE_GROUP_NAME
  disable_bgp_route_propagation = false

  route {
    name           = "to-firewall"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.outbound.ip_configuration[0].private_ip_address
  }

}