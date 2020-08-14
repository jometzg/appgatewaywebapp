# Impact of service plans on VNet integration

App services (web apps) make use of an app service plan. This is the compute instance that actually executes the code deployed to an app service. One or more app services can share an app service plan. This is a good way to achieve compute density and is a good way of achieving cost savings when deploying a number of web applications which do not get much traffic. More detail on app service plans [here](https://docs.microsoft.com/en-us/azure/app-service/overview-hosting-plans)  

Service plans impact what can be done with VNet integration. This is documented, but it is not really obvious what this means for an architecture. This section delves into a little more detail on what can and cannot be done with multi-tier web apps and restricting access to these.

## Scenario
Customers often have architectures where there is a front-end web application and a backend API application that serves requests to the front end. The API web application then interacts with a data source or other on-premise resources.
It is also often the case that a number of separate applications (each of which comprises the front-end and API together) may need to share a common virtual network infrastructure - often because in an organisation virtual networking and applications are managed by separate teams.

![alt text](https://github.com/jometzg/appgatewaywebapp/blob/master/serviceplans/generic-multi-tier.png "generic multi-tier application")

Looking at this architecture in terms of Azure networking and app services, here is an approach:

![alt text](https://github.com/jometzg/appgatewaywebapp/blob/master/serviceplans/azure-multi-tier.png "Azure multi-tier application")

In the above diagram we have the front-end web apps which are app restricted to the gateway subnet, which also has an application gateway instance. In this way, only requests from the application gateway will be accepted by the front-end web apps (or more strictly, on requests from the gateway subnet). The middle-tier (or API) web apps are likewise app restricted to the "webapp" subnet, which is also the subnet to which the front-end web app are VNet restricted. The middle-tier (or API) web apps are VNet integrated to allow APIs to access other VNet resources via peering or on-premise resources via an Express Route gateway.

## The documentation
The documentation on app services [VNet integration](https://docs.microsoft.com/en-us/azure/app-service/web-sites-integrate-with-vnet#regional-vnet-integration) states a number of limitations:
![alt text](https://github.com/jometzg/appgatewaywebapp/blob/master/serviceplans/doc-excerpt.png "VNet integrations limitations")

The item highlighed **The integration subnet can be used by only one App Service plan** is the the most important for planning how to implement a multi-tier web application with VNet integration.

## Three potential patterns
Depending on the customer needs, the above limitation results in what look like three potential approaches. These will be descibed in turn.

### Pattern One
![alt text](https://github.com/jometzg/appgatewaywebapp/blob/master/serviceplans/overall-shared-service-plan.png "sharing service plans")

This is the simplest pattern in terms of providing restrictions to the front-end and middle-tier (API) apps and allowing the API app to access onwards resources.

The impact of the service plan limitation means that ALL of the web apps will have to share the same service plan for this to work. This has the obvious limitations of scale and lack of isolation between the compute used for the web apps. 

Where this pattern may be used is for low-scale web apps where a shared service plan is not an issue or where network restrictions mean a common VNet and subnets are required for all of the web app workloads.

### Pattern Two
![alt text](https://github.com/jometzg/appgatewaywebapp/blob/master/serviceplans/separate-service-plan.png "separate on each tier service plans")

This is an extension to pattern one. This means that there are two service plans, one for the front-end and one for the middle-tier (API). So this has more scalability than pattern one, but all applications still share common front-end and middle-tier service plans.
The extra complexity over pattern one is probably worth it for the extra scalability.

### Pattern Three
![alt text](https://github.com/jometzg/appgatewaywebapp/blob/master/serviceplans/multi-subnet.png "subnet for each web app")

Where scalability of the web apps is important and the deployment team can influence the design of the VNet, then this pattern can be used. But the big factor here is that there are a pair of subnets for each application on the VNet.

## Summary
The service plan limitations for VNet integration of app services requires you to think more carefully about whether you can tolerate web apps sharing a service plan, thus allowing a number of applications to share common VNet subnets, or whether you need to define subnets per application in order to have service plans per application and therefore the most flexibility in terms of scaling your applications. With some customers, VNets are implemented by separate teams and this may also inform this decision.

