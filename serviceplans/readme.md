# Impact of service plans on VNet integration

Service plans impact what can be done with VNet integration. This is documented, but it is not really obvious what this means for an architecture. This section delves into a little more detail on what can and cannot be done with multi-tier web apps and restricting access to these.

## Scenario
Customers often have architectures where there is a front-end web application and a backend API application that serves requests to the front end. The API web application then interacts with a data source or other on-premise resources.
It is also often the case that a number of separate applications (each of which comprises the front-end and API together) may need to share a common virtual network infrastructure - often because in an organisation virtual networking and applications are managed by separate teams.

