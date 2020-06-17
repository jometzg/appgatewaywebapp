# Setting up SSL
The application gateway can be configured to have an SSL certificate. This needs to be a PFX type as is used with other Azure services.

This section is a brief guide to creating the SSL certificate and installing this in the application gateway.

## Create an SSL Certificate
An internet domain name is needed prior to creating an SSL certificate. It is against one of the subdomains of this domain that the certificate is created. As part of this, it requires that the owner of the domain proves ownership by setting "TXT" values that the certificate authority checks during the certificate provisioning process.

This guide uses (Let's Encrypt)[https://letsencrypt.org/]
