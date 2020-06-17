resource "azurerm_public_ip" "firewallpip" {
  name                = "firewallpip"
  location            = var.LOCATION
  resource_group_name = var.RESOURCE_GROUP_NAME
  allocation_method   = "Static"
  sku                 = "Standard"
}


resource "azurerm_firewall" "outbound" {
  name                = "testfirewall"
  location            = var.LOCATION
  resource_group_name = var.RESOURCE_GROUP_NAME

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.hb_firewall_subnet.id
    public_ip_address_id = azurerm_public_ip.firewallpip.id
  }
}

resource "azurerm_firewall_application_rule_collection" "example" {
  name                = "testcollection"
  azure_firewall_name = azurerm_firewall.outbound.name
  resource_group_name = var.RESOURCE_GROUP_NAME
  priority            = 100
  action              = "Allow"

  rule {
    name = "ifconfig"

    source_addresses = [
      "*",
    ]

    target_fqdns = [
      "ifconfig.co",
    ]

    protocol {
      port = "80"
      type = "Http"
    }
  }
}