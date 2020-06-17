# Private App Services behind an Application Gateway
## Rationale
Azure platform (PaaS) services provide a level of abstraction higher that infrastructure services (IaaS). This frees the application developer to concentrate their application rather than the supporting infrastructure.

Increasingly customers are also adopting network architectures which limit the visibility of services, as another layer of security. Azure App Services (web apps) have a special SKU to support private use cases - the application service environment (ASE). This creates an app service infrastructure inside a virtual network (VNet). This is often overkill.

In recent times, app services have gained the ability to restrict their inbound connections to a VNet subnet and to also be able to call other private services in other VNets or remote networks that are routable from VNets.

## This Guide
This is a guide on how to configure an Azure app service (web app) to only be visible inside an VNet and fronted by application gateway, so that it can be accessed via a private IP address or via a public IP address (as separate use cases).

In addition this also demonstrates how this web app can access other private VNet services and how to control the ability of the web app to access internet services using the Azure firewall.

This is all using the normal Azure web app and its service point based integration to VNets - so is much more cost-effective than using Application Service Environments (ASE).

## Architecture
![alt text](https://github.com/jometzg/appgatewaywebapp/blob/master/web-app-app-gateway.png "private web app")

In the above diagram, there an an Azure Application Gateway that provides the entry point to the main web application. An application Gateway V2 can have both a public and a private IP address. For a truly private web application, the public endpoint to the gateway would not be used, but it is useful in this demonstration for ease of use.

The main web app that sits in the application gateway's VNet, is a simple .NET Core web app, which has a couple of menu items that can call external web services.

A virtual machine is also included to represent an internal user's PC/machine. Someone can run a remote desktop session to this machine to access the private endpoint of the application gateway.

There are two virtual networks, one of which can represent a workload VNet and the other a remote services Vnet. These VNets are peered to provide a routing mechanism for requests. This could also be viewed as the hub and spoke architecture, where the application gateway VNet represents a spoke and the target VNet a hub.

In the target VNet there are two web APIs, one hosted in another app services instance and the other in an Azure Container Instance (ACI). The latter is useful as it can be exposted directly with a private IP address. The target web app also has its access restricted to a subnet in the target VNet - so it is also not exernally accessible.

Finally, there is an Azure firewall in the target VNet. A custom route has been assigned to the main web app's subnet for force tunnel all requests from the web app to the firewall. The firewall by default blocks all outbound access, but will be configured to to allow a specific internet-hosted web API.

## The web app
![alt text](https://github.com/jometzg/appgatewaywebapp/blob/master/web-app.png "private web app front end")

As can be seen, this is a simple web app that has some menus:
* Weather (ACI) - calls one of the web APIs in the target VNet to return some weather-related JSON. This one is ACI hosted
* Weather (web app) - As above, but hosted my Azure app services
* IP Address - calls an internet hosted web API that is at [What is my IP Address](https://ifconfig.co/) 
* Blocked - this is another internet hosted IP address service  [Apify](https://www.ipify.org/) but this has not been whitelisted by the firewall

You can also see that the application gateway has a custom domain and an SSL certificate for that configured.

### Note: 
* The internally-facing version of this web app, uses the usual HTTPS port of 443. So this does not conflict, the public port is 445. In normal circumstances the default SSL port 443 would be used.
* In order provide this capability requires a internet domain name and the ability to set its DNS settings. This demo used LetsEncrypt to generate a wildcard certificate for the domain. 
