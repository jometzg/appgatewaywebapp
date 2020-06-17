resource "azurerm_resource_group" "webapp-gateway-rg" {
  name     = var.RESOURCE_GROUP_NAME
  location = var.LOCATION
}

resource "azurerm_virtual_network" "hub_vnet" {
  name                = "hub_vnet"
  location            = var.LOCATION
  resource_group_name = var.RESOURCE_GROUP_NAME
  address_space       = ["${var.HUB_VNET_ADDRESS_SPACE}"]
}

resource "azurerm_subnet" "hb_default_subnet" {
  name                 = "default"
  resource_group_name  = var.RESOURCE_GROUP_NAME
  virtual_network_name = azurerm_virtual_network.hub_vnet.name
  address_prefixes       = [var.HUB_DEFAULT_SUBNET_ADDRESS_PREFIX]
}

resource "azurerm_subnet" "hb_firewall_subnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = var.RESOURCE_GROUP_NAME
  virtual_network_name = azurerm_virtual_network.hub_vnet.name
  address_prefixes       = [var.HUB_FIREWALL_SUBNET_ADDRESS_PREFIX]
}

resource "azurerm_subnet" "hb_webapp_subnet" {
  name                 = "webappsubnet"
  resource_group_name  = var.RESOURCE_GROUP_NAME
  virtual_network_name = azurerm_virtual_network.hub_vnet.name
  address_prefixes       = [var.HUB_WEBAPP_SUBNET_ADDRESS_PREFIX]

  delegation {
    name = "delegation"

    service_delegation {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }

}

resource "azurerm_network_profile" "aci_net_profile" {
  name                = "${var.PREFIX}netprofile"
  location            = var.LOCATION
  resource_group_name = var.RESOURCE_GROUP_NAME

  container_network_interface {
    name = "${var.PREFIX}cnic"

    ip_configuration {
      name      = "${var.PREFIX}ipconfig"
      subnet_id = azurerm_subnet.hb_webapp_subnet.id
    }
  }
}
