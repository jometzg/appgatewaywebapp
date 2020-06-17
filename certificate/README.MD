# Setting up SSL
The application gateway can be configured to have an SSL certificate. This needs to be a PFX type as is used with other Azure services.

This section is a brief guide to creating the SSL certificate and installing this in the application gateway.

## Create an SSL Certificate
An internet domain name is needed prior to creating an SSL certificate. It is against one of the subdomains of this domain that the certificate is created. As part of this, it requires that the owner of the domain proves ownership by setting "TXT" values that the certificate authority checks during the certificate provisioning process.

This guide uses (Let's Encrypt)[https://letsencrypt.org/]

Following guide here [https://medium.com/@saurabh6790/generate-wildcard-ssl-certificate-using-lets-encrypt-certbot-273e432794d7]

Using a Linux command prompt - this could be Windows Subsystem for Linux (WSL) or even an Raspberry Pi (which is what was used)

`./certbot-auto certonly \
	--manual
	--preferred-challenges=dns \
	--email XXXXXX@gmail.com \
	--server https://acme-v02.api.letsencrypt.org/directory \
	--agree-tos \
-d *.YYYYYY.com
'
where:
* you use the domain that you have admin rights to
* an email address of the domain admin

This will then give you a challenge to set a specific TXT setting in your domain's DNS services

