# Setting up SSL
The application gateway can be configured to have an SSL certificate. This needs to be a PFX type as is used with other Azure services.

This section is a brief guide to creating the SSL certificate and installing this in the application gateway.

## Create an SSL Certificate
An internet domain name is needed prior to creating an SSL certificate. It is against one of the subdomains of this domain that the certificate is created. As part of this, it requires that the owner of the domain proves ownership by setting "TXT" values that the certificate authority checks during the certificate provisioning process.

This guide uses [Let's Encrypt](https://letsencrypt.org/)

Following guide here [Medium](https://medium.com/@saurabh6790/generate-wildcard-ssl-certificate-using-lets-encrypt-certbot-273e432794d7)

Using a Linux command prompt - this could be Windows Subsystem for Linux (WSL) or even an Raspberry Pi (which is what was used)

```
./certbot-auto certonly \
	--manual
	--preferred-challenges=dns \
	--email XXXXXX@gmail.com \
	--server https://acme-v02.api.letsencrypt.org/directory \
	--agree-tos \
-d *.YYYYYY.com
```
where:
* you use the domain that you have admin rights to
* an email address of the domain admin

This will then give you a challenge to set a specific TXT setting in your domain's DNS services

![alt text](https://github.com/jometzg/appgatewaywebapp/blob/master/certificate/dns-challenge.png "DNS Challenge")
```
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Please deploy a DNS TXT record under the name
_acme-challenge.YYYYYY.com with the following value:
 
QlUBMmSXHim8WvtjD2zeQ9bULLdpinmW-54mCJphPks
 
Before continuing, verify the record is deployed.
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Press Enter to Continue
Waiting for verification...
Cleaning up challenges
 
IMPORTANT NOTES:
- Congratulations! Your certificate and chain have been saved at:
   /etc/letsencrypt/live/metronzone.com/fullchain.pem
   Your key file has been saved at:
   /etc/letsencrypt/live/YYYYYY.com/privkey.pem
   Your cert will expire on 2020-09-02. To obtain a new or tweaked
   version of this certificate in the future, simply run certbot
   again. To non-interactively renew *all* of your certificates, run
   "certbot renew"
- If you like Certbot, please consider supporting our work by:
 
   Donating to ISRG / Let's Encrypt:   https://letsencrypt.org/donate
   Donating to EFF:                    https://eff.org/donate-le
```

This should result in some certificate files, but these need to be additionally processed to generate a PFX.
```
sudo openssl pkcs12 -export -in /etc/letsencrypt/live/YYYYYY.com/fullchain.pem -inkey /etc/letsencrypt/live/metronzone.com/privkey.pem -out YYYYYY.pfx
Enter Export Password: b***s
Verifying - Enter Export Password:
```

## Use SSL Certificate
You should now have a PFX file that can be installed on the application gateway:

![alt text](https://github.com/jometzg/appgatewaywebapp/blob/master/certificate/upload-to-gateway.png "Upload to application gateway")

It should also be noted that DNS needs to be set to the application gateway IP address. For the public IP address, this will need to be set in your domain's DNS settings. For private IP addresses, then you DNS in your network should be used. This could be an Azure DNS zone or an on-premise DNS.

## Terraform
The Terraform definition for the application gateway can also be used to set the SSL certificate and this is the ideal approach.

```
A ssl_certificate block supports the following:

name - (Required) The Name of the SSL certificate that is unique within this Application Gateway

data - (Optional) PFX certificate. Required if key_vault_secret_id is not set.

password - (Optional) Password for the pfx file specified in data. Required if data is set.

key_vault_secret_id - (Optional) Secret Id of (base-64 encoded unencrypted pfx) Secret or Certificate object stored in Azure KeyVault. You need to enable soft delete for keyvault to use this feature. Required if data is not set.
```
The configuration is shown here [Terraform - application gateway](https://www.terraform.io/docs/providers/azurerm/r/application_gateway.html#ssl_certificate)

There is an alternative configuration that uses key vault. But that would also require the application gateway to authenticate against the specific key vault where the certifcate is loaded.
