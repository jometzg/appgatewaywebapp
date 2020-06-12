# Using App Services behind an Application Gateway
This is a guide on how to configure an Azure app service (web app) to only be visible inside an VNet and fronted by application gateway, so that it can be accessed via a private IP address.
In addition this also demonstrates how this web app can access other private VNet services and how to control the ability of the web app to access internet services using the Azure firewall.
This is all using the normal Azure web app and its service point based integration to VNets - so is much more cost-effective than using Application Service Environments (ASE).

## Overall Shape
![alt text](https://github.com/jometzg/appgatewaywebapp/blob/master/diagram.png "private web app")

