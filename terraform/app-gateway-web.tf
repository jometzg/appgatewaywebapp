# since these variables are re-used - a locals block makes this more maintainable
locals {
  backend_address_pool_name      = "AppService"
  frontend_port_name             = "${azurerm_virtual_network.workload_vnet.name}-feport"
  frontend_ip_configuration_name = "${azurerm_virtual_network.workload_vnet.name}-feip"
  http_setting_name              = "${azurerm_virtual_network.workload_vnet.name}-be-htst"
  listener_name                  = "${azurerm_virtual_network.workload_vnet.name}-httplstn"
  request_routing_rule_name      = "${azurerm_virtual_network.workload_vnet.name}-rqrt"
  redirect_configuration_name    = "${azurerm_virtual_network.workload_vnet.name}-rdrcfg"
}

resource "azurerm_public_ip" "gateway_public" {
  name                = "gateway_public"
  resource_group_name = var.RESOURCE_GROUP_NAME
  location            = var.LOCATION
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_application_gateway" "network" {
  name                = "example-appgateway"
  resource_group_name = var.RESOURCE_GROUP_NAME
  location            = var.LOCATION

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 1
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = azurerm_subnet.wl_gateway_subnet.id
  }

 // public IP address
  frontend_port {
    name = "exthttp"
    port = 81
  }

  frontend_ip_configuration {
    name                 = "${local.frontend_ip_configuration_name}-public"
    public_ip_address_id = azurerm_public_ip.gateway_public.id
  }

// private IP address
  frontend_port {
    name = local.frontend_port_name
    port = 80
  }
  
  frontend_ip_configuration {
    name                          = "${local.frontend_ip_configuration_name}-private"
    subnet_id                     = azurerm_subnet.wl_gateway_subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.private_ip_address
  }

  backend_address_pool {
    name = local.backend_address_pool_name
    fqdns = [azurerm_app_service.sample.default_site_hostname]
  }

  probe {
    name                = "probe"
    protocol            = "https"
    path                = "/"
    pick_host_name_from_backend_http_settings = true
    interval            = "30"
    timeout             = "30"
    unhealthy_threshold = "3"
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    pick_host_name_from_backend_address = true
    path                  = "/"
    port                  = 443
    protocol              = "Https"
    request_timeout       = 1
    probe_name            = "probe"
  }

  http_listener {
    name                           = "${local.listener_name}-public"
    frontend_ip_configuration_name = "${local.frontend_ip_configuration_name}-public"
    frontend_port_name             = "exthttp"
    protocol                       = "Http"
  }

  http_listener {
    name                           = "${local.listener_name}-private"
    frontend_ip_configuration_name = "${local.frontend_ip_configuration_name}-private"
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "${local.request_routing_rule_name}-public"
    rule_type                  = "Basic"
    http_listener_name         = "${local.listener_name}-public"
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }

  request_routing_rule {
    name                       = "${local.request_routing_rule_name}-private"
    rule_type                  = "Basic"
    http_listener_name         = "${local.listener_name}-private"
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }
}

resource "azurerm_app_service_plan" "sample" {
  name                = "example-appserviceplan"
  location            = var.LOCATION
  resource_group_name = var.RESOURCE_GROUP_NAME

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "sample" {
  name                = "jj-example-app-service"
  location            = var.LOCATION
  resource_group_name = var.RESOURCE_GROUP_NAME
  app_service_plan_id = azurerm_app_service_plan.sample.id

  site_config {
    dotnet_framework_version = "v4.0"
    scm_type                 = "LocalGit"

    ip_restriction {
        virtual_network_subnet_id =  azurerm_subnet.wl_gateway_subnet.id
    }

    ip_restriction {
        virtual_network_subnet_id =  azurerm_subnet.wl_default_subnet.id
    }
  }

  app_settings = {
    "externalurl"   = "http://ifconfig.co/ip"
    "targeturl"     = "http://172.19.1.5/weatherforecast"
    "webapptarget"  = "https://jjdest.azurewebsites.net/weatherforecast"
    "blockedurl"    = "https://api.ipify.org/?format=json"
  }
}

resource "azurerm_app_service_virtual_network_swift_connection" "sample-app-webappsubnet" {
  app_service_id = azurerm_app_service.sample.id
  subnet_id      = azurerm_subnet.wl_webapp_subnet.id
}
