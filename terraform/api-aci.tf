resource "azurerm_container_group" "weatherforecast-api" {
  name                = "weatherforecast-api"
  location            = var.LOCATION
  resource_group_name = var.RESOURCE_GROUP_NAME

  ip_address_type = "private"
  os_type         = "Linux"

  network_profile_id = azurerm_network_profile.aci_net_profile.id

  restart_policy = "Never"

  image_registry_credential {
    server   = var.IMAGE_REGISTRY_SERVER
    username = var.IMAGE_REGISTRY_USERNAME
    password = var.IMAGE_REGISTRY_PASSWORD
  }

  container {
    name   = "api"
    image  = var.DOCKER_IMAGE
    cpu    = var.CPU
    memory = var.MEMORY

    ports {
      port     = var.DOCKER_PORT
      protocol = "TCP"
    }
  }
}