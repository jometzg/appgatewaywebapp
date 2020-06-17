# Logging
Logging is important, both in terms of looking for service health, but also for a form of audit trail of users' access to a service.

There are two major logging components
* log analytics workspaces
* application insights

## Log Analytics
Sources of logs in this demo:
* application gateway and WAF if enabled
* web application diagnostics
* firewall

Log analytics workspaces are essentially write only with normal permissions. This means that neither the application components, nor a user of a log analytics workspace can amend or delete data (outside of the usual data retention settings). 

https://docs.microsoft.com/en-us/azure/azure-monitor/platform/data-security

## Application Insights
This is more of an application level diagnostic tool, but can provide logs on end-user behaviour, dependencies etc. This is the goto place for understanding how a web application behaves.
