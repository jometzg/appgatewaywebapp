output "workload_webapp_subnet_id" {
  value = "${azurerm_subnet.wl_webapp_subnet.id}"
}


//output "firewall-ip-address" {
//  value = "${azurerm_firewall.outbound.ip_configuration[0].private_ip_address}"
//}