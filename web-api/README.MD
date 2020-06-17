# Web API

This can be any web API, but in this case, the Visual Studio web API template has been used that surfaces an API endpoint that returns some weather data.

This API can be deployed either in a container or a web app. The container hosted in Azure Container Instances (ACI) allows VNet integration and so is presented as a private IP address. 

The web app version runs on app services, but restricted to a VNet subnet. This is technically different to that of the ACI implementation of the API, and so demonstrates both private IP address and web app integration.

