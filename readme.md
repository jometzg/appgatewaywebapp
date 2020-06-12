# Using App Services behind an Application Gateway
This is a guide on how to configure an Azure app service (web app) to only be visible inside an VNet and fronted by application gateway, so that it can be accessed via a private IP address.

In addition this also demonstrates how this web app can access other private VNet services and how to control the ability of the web app to access internet services using the Azure firewall.

This is all using the normal Azure web app and its service point based integration to VNets - so is much more cost-effective than using Application Service Environments (ASE).

## Overall Shape
![alt text](https://github.com/jometzg/appgatewaywebapp/blob/master/web-app-app-gateway.png "private web app")

In the above diagram, there an an Azure Application Gateway that provides the entry point to the main web application. An application Gateway V2 can have both a public and a private IP address. For a truly private web application, the public endpoint to the gateway would not be used, but it is useful in this demonstration for ease of use. 

A virtual machine is also included to represent an internal user's PC/machine. Someone can run a remote desktop session to this machine to access the private endpoint of the application gateway.

There are two virtual networks, one of which can represent a workload VNet and the other a remote services Vnet. These VNets are peered to provide a routing mechanism for requests. This could also be viewed as the hub and spoke architecture, where the application gateway VNet represents a spoke and the target VNet a hub.

In the 
