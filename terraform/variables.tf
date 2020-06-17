variable "RESOURCE_GROUP_NAME" {
  type    = string
  default = "webapp-gateway-rg"
}

variable "LOCATION" {
  type    = string
  default = "westeurope"
}

variable "PREFIX" {
  type    = string
  default = "appgateway"
}

variable "HUB_VNET_ADDRESS_SPACE" {
  type    = string
  default = "172.0.0.0/16"
}


variable "HUB_DEFAULT_SUBNET_ADDRESS_PREFIX" {
  type    = string
  default = "172.0.0.0/24"
}

variable "HUB_FIREWALL_SUBNET_ADDRESS_PREFIX" {
  type    = string
  default = "172.0.1.0/24"
}

variable "HUB_WEBAPP_SUBNET_ADDRESS_PREFIX" {
  type    = string
  default = "172.0.2.0/24"
}

variable "WORKLOAD_VNET_ADDRESS_SPACE" {
  type    = string
  default = "172.1.0.0/16"
}

variable "WORKLOAD_DEFAULT_SUBNET_ADDRESS_PREFIX" {
  type    = string
  default = "172.1.0.0/24"
}

variable "WORKLOAD_GATEWAY_SUBNET_ADDRESS_PREFIX" {
  type    = string
  default = "172.1.1.0/24"
}

variable "WORKLOAD_WEBAPP_SUBNET_ADDRESS_PREFIX" {
  type    = string
  default = "172.1.2.0/24"
}

variable "WORKLOAD_BASTION_SUBNET_ADDRESS_PREFIX" {
  type    = string
  default = "172.1.3.0/24"
}

variable "IMAGE_REGISTRY_SERVER" {
  type    = string
  default = "ACI_NAME.azurecr.io"
}

variable "IMAGE_REGISTRY_USERNAME" {
  type    = string
  default = "ACI_USER"
}

variable "IMAGE_REGISTRY_PASSWORD" {
  type    = string
  default = "ACH_ACCESS_KEY"
}

variable "CPU" {
  type    = string
  default = "1.0"
}

variable "MEMORY" {
  type    = string
  default = "4.0"
}

variable "DOCKER_IMAGE" {
  type    = string
  default = "ACI_NAME.azurecr.io/webapplication3"
}

variable "DOCKER_PORT" {
  type    = string
  default = "80"
}

variable "WEBAPP_HOSTNAME" {
  type    = string
  default = "UNIQUE_NAME.azurewebsites.net"
}

variable "private_ip_address" {
  description = "The Private IP Address to use for the Application Gateway."
  default = "172.1.1.10"
}
