# Impact of service plans on VNet integration

App services (web apps) make use of an app service plan. This is the compute instance that actually executes the code deployed to an app service. One or more app services can share an app service plan. This is a good way to achieve compute density and is a good way of achieving cost savings when deploying a number of web applications which do not get much traffic. More detail on app service plans [here](https://docs.microsoft.com/en-us/azure/app-service/overview-hosting-plans)  

Service plans impact what can be done with VNet integration. This is documented, but it is not really obvious what this means for an architecture. This section delves into a little more detail on what can and cannot be done with multi-tier web apps and restricting access to these.

## Scenario
Customers often have architectures where there is a front-end web application and a backend API application that serves requests to the front end. The API web application then interacts with a data source or other on-premise resources.
It is also often the case that a number of separate applications (each of which comprises the front-end and API together) may need to share a common virtual network infrastructure - often because in an organisation virtual networking and applications are managed by separate teams.

![alt text](https://github.com/jometzg/appgatewaywebapp/blob/master/serviceplans/generic-multi-tier.png "generic multi-tier application")

## The documentation
The documentation on app services [VNet integration](https://docs.microsoft.com/en-us/azure/app-service/web-sites-integrate-with-vnet#regional-vnet-integration) states a number of limitations:
![alt text](https://github.com/jometzg/appgatewaywebapp/blob/master/serviceplans/doc-excerpt.png "VNet integrations limitations")

The item highlighed **The integration subnet can be used by only one App Service plan** is the the most important for planning how to implement a multi-tier web application with VNet integration.

## Three potential patterns
Depending on the customer needs, the above limitation results in what look like three potential approaches. These will be descibed in turn.

### Pattern One
![alt text](https://github.com/jometzg/appgatewaywebapp/blob/master/serviceplans/shared-service-plan.png "sharing service plans")

