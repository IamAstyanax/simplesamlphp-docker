# SimpleSAMLPHP in Docker
SimpleSAMLPHP in docker. Based on debian 12 base image, supervisord, PHP8.2, nginx, and SimpleSAMLPHP 2.4.1.

## Features and container options specific to this build
- Custom email address driven multiauth.
- Attribute injection using PHP instead of scoping LDAP attributes.

## How to build

You will need a modern linux environment with git, docker, and docker-compose installed.

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

| Variable                            | Description                                                                                                                           |
| ----------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------- |
| `CONFIG_AUTHADMINPASSWORD_ARG`      | The password used to access the SimpleSAMLphp web admin interface. This should be strong and secret.                                  |
| `CONFIG_SECRETSALT_ARG`             | A random string used for cryptographic purposes, such as hashing. Must be unique and kept secret.                                     |
| `CONFIG_TECHNICALCONTACT_NAME_ARG`  | The name of the technical contact person for the service. Displayed on error or contact pages.                                        |
| `CONFIG_TECHNICALCONTACT_EMAIL_ARG` | Email address of the technical contact. Used for support or issue reporting.                                                          |
| `CONFIG_SHOWERRORS_ARG`             | Boolean value (`true`/`false`) that controls whether detailed errors are shown in the web interface. Should be `false` in production. |
| `CONFIG_ERRORREPORTING_ARG`         | Enables or disables PHP error reporting. Usually set to `true` for debugging and `false` in production.                               |
| `CONFIG_ADMINPROTECTINDEXPAGE_ARG`  | When `true`, requires authentication to access the admin index page.                                                                  |
| `CONFIG_ADMINPROTECTMETADATA_ARG`   | When `true`, restricts access to the metadata listing page. Can be `false` in dev/test environments.                                  |
| `CONFIG_PRODUCTION_ARG`             | Indicates whether the environment is a production environment. Affects behaviors like error reporting.                                |
| `CONFIG_LOGGINGLEVEL_ARG`           | Sets the level of logging. Common values: `ERROR`, `WARNING`, `NOTICE`, `INFO`, `DEBUG`.                                              |
| `CONFIG_LOGGINGHANDLER_ARG`         | Defines how logs are handled. Common value is `file`, but could also be `syslog` or custom handlers.                                  |
| `CONFIG_ENABLESAML20IDP_ARG`        | Enables the SAML 2.0 Identity Provider functionality. Set to `true` if SimpleSAMLphp will act as an IdP.                              |
| `CONFIG_TIMEZONE`                   | Sets the default PHP timezone. Example: `America/Chicago`.                                                                            |
| `CONFIG_SIMPLESAMLPHPURL`           | The base URL of the SimpleSAMLphp instance, typically pointing to the IdP or SP endpoint.                                             |


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

Below is an example of LDAPs configuration. the `connection_string`, `port` `search.base` `search.username` and `search.password` are most important. You can add and remove attributes to grab, these are what we typically request under `attributes`.

Docs: https://simplesamlphp.org/docs/contrib_modules/ldap/ldap.html 

LDAP configuration example:

``````
    'ldapexample.org' => array(
        'ldap:Ldap',
        'description' => 'LDAP EXAMPLE', # DESCRIPTION OF LDAP DOMAIN
        'connection_string' => 'ldaps://ldaps.example.org', # LDAPS URL
        'enable_tls' => FALSE,
        'debug' => FALSE,
        'timeout' => 10,
        'port' => 636, # or 389 for non-ssl ldap
        'referrals' => FALSE,
        'attributes' => array('sAMAccountName', 'o', 'mail', 'userPrincipalName', 'givenName', 'sn', 'displayName', 'objectClass', 'description', 'telephoneNumber', 'distinguishedName', 'memberOf', 'proxyAddresses', 'homeDirectory', 'employeeID', 'employeeNumber', 'objectCategory'), # add and remove attributes as you see fit
        'dnpattern' => NULL,
        'search.enable' => TRUE,
        'search.base' => ['OU=your,DC=search,DC=dn'], # your Active Directory / OPENLDAP search base
        'search.attributes' => array('mail'), # we search for mail attribute
        'search.username' => 'idp@example.org', # YOUR LDAP SEARCH USERNAME
        'search.password' => 'examplepassword', # YOUR LDAP SEARCH PASSWORD
        'priv.read' => FALSE,
        'priv.username' => NULL,
        'priv.password' => NULL,
        'help' => array(
            'en' => 'Generic Help Text'
        ),
        'options' => array( 
            //	LDAP_OPT_X_TLS_REQUIRE_CERT => LDAP_OPT_X_TLS_NEVER,
                'x_tls_require_cert' => 0,
                
            )
    ),

``````

Google Authentication Example

Official Docs: https://simplesamlphp.org/docs/stable/simplesamlphp-googleapps.html




## Support the project

https://simplesamlphp.org/

