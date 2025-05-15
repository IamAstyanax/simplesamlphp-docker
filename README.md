# SimpleSAMLPHP in Docker
SimpleSAMLPHP in docker. Based on debian 12 base image, supervisord, PHP8.2, nginx, and SimpleSAMLPHP 2.4.0.

## Features and container options specific to this build
- Custom email address driven multiauth.
- Attribute injection using PHP instead of scoping LDAP attributes.

## How to build

Clone repository:

`git clone git@github.com:IamAstyanax/simplesamlphp-docker.git` 

Move into proper directory:

`cd simplesamlphp-docker`

Run setup script:

`bash setup-ssp.sh  `

This will generate self signed certificates, start memcache containers, and start simplesamlPHP listening on port 443.

Running this without modification assumes you are going to run Simplesaml behind a load balancer for SSL termination. If you are not, I would recommend checking out `acme.sh` for certificate management.

## Generate Self Signed Certificate and Key
openssl req -x509 -nodes -newkey rsa:2048 \
  -keyout ./container_files/certs/ssp.key \
  -out ./container_files/certs/ssp.crt \
  -days 365 \
  -subj "/C=US/ST=State/L=City/O=Organization/CN=yourdomain.com"

## Environment Variables

## Attribute injection using PHP
The attributes in this docker build of SSP uses PHP to inject custom attributes during `authproc`. The authproc is configured at `/container_files/simplesamlphp/metadata/saml20-idp-hosted.php`

Based on the mail attribute we scope the organization and then inject attributes from the domain entered at login.

For example, if user@nebraskaschool.edu logs into the IdP - whatever attributes are defined under `/container_files/simplesamlphp/metadata/attribute-injection-by-domain.php` for @nebraskaschool.edu will get slapped onto the user when an initiated by an SP login.

This allows multiple entities to have their own global custom attributes without the need for extending an LDAP schema. You could get very technical with this and could probably even write PHP to add attributes based on username or member of xyz group if desired. For our use case, we needed global based attributes specific to each entity logging in.

Here is an example:
```
   
   '@nebraskaschool.edu' => [
        'nebraskastateID' => '1234',
        'nebraskaSchoolID' => 'Nebraska-School',
        'CampusID' => 'TheCampusID',
        'StateDistrictNumber' => '121212',
        'InCommonAttribute01' => 'ThisRandomAttribute',
        'custom-attribute-06' => 'custom-attribute-value-06',
    ],
    
```
## Custom Multiauth 
The multiauth module in this repository has been modified slightly. In the stock version of simplesaml; during multiauth array, the default theme displays a list of choices for a user to pick from when logging in via IdP or SP initiated login. 

We changed that such that when a user types in their email, based on the domain it will pick the entity for them.

## LDAP and Google-Based multiauth
I added the bare necessities to get LDAPs or Google based authentication to work with our custom multiauth. Obviously for entities connecting with google based authentication, you need the metadata files added into `saml20-idp-remote.php`

Typing in `test@ldapexample.org` will render the authentication phase, but obviously will not work.

## Support the project

https://simplesamlphp.org/

