<?php

$config = [
    /*
     * When multiple authentication sources are defined, you can specify one to use by default
     * in order to authenticate users. In order to do that, you just need to name it "default"
     * here. That authentication source will be used by default then when a user reaches the
     * SimpleSAMLphp installation from the web browser, without passing through the API.
     *
     * If you already have named your auth source with a different name, you don't need to change
     * it in order to use it as a default. Just create an alias by the end of this file:
     *
     * $config['default'] = &$config['your_auth_source'];
     */

    // This is a authentication source which handles admin authentication.
    'admin' => [
        // The default is to use core:AdminPassword, but it can be replaced with
        // any authentication source.

        'core:AdminPassword',
    ],


    // An authentication source which can authenticate against SAML 2.0 IdPs.
    'default-sp' => [
        'saml:SP',

        // The entity ID of this SP.
        'entityID' => 'https://myapp.example.org/',

        // The entity ID of the IdP this SP should contact.
        // Can be NULL/unset, in which case the user will be shown a list of available IdPs.
        'idp' => null,

        // The URL to the discovery service.
        // Can be NULL/unset, in which case a builtin discovery service will be used.
        'discoURL' => null,

        /*
         * If SP behind the SimpleSAMLphp in IdP/SP proxy mode requests
         * AuthnContextClassRef, decide whether the AuthnContextClassRef will be
         * processed by the IdP/SP proxy or if it will be passed to the original
         * IdP in front of the IdP/SP proxy.
         */
        'proxymode.passAuthnContextClassRef' => false,

        /*
         * The attributes parameter must contain an array of desired attributes by the SP.
         * The attributes can be expressed as an array of names or as an associative array
         * in the form of 'friendlyName' => 'name'. This feature requires 'name' to be set.
         * The metadata will then be created as follows:
         * <md:RequestedAttribute FriendlyName="friendlyName" Name="name" />
         */
        /*
        'name' => [
            'en' => 'A service',
            'no' => 'En tjeneste',
        ],

        'attributes' => [
            'attrname' => 'urn:oid:x.x.x.x',
        ],
        'attributes.required' => [
            'urn:oid:x.x.x.x',
        ],
        */
    ],

    'custom-multiauth' => array(
        'multiauth:MultiAuth',
        'sources' => array(
            
            # example Google option
            'Google-Auth-example' => array(
                'text' => array(
                    'en' => '@yourgoogledomain.org',
                ),
                'help' => array(
                    'en' => 'Generic Help Text'
                ),
                'css-class' => 'SAML',
            ),

            ## example LDAP option
            'ldapexample.org' => array(
                'text' => array(
                    'en' => '@ldapexample.org',
                ),
                'help' => array(
                    'en' => 'Generic Help Text'
                ),
                'alias' => 'custom-multiauth-AD',
                'css-class' => 'SAML',
            ),
        ),
    ),

    #Example Google Configuration
    'Google-Auth-Source' => array(
        'saml:SP',
        'entityID' => 'https://sp.example.org/simplesaml/module.php/saml/sp/metadata.php/Google-example',
        'idp' => 'https://youridpurl.com',
        'help' => array(
            'en' => 'Your Generic Text Help'
        ),
    ),

    ## Example LDAP configuration
    'ldapexample.org' => array(
        'ldap:Ldap',
        'description' => 'LDAP EXAMPLE',
        'connection_string' => 'ldaps://ldaps.example.org', # you can also use non-ssl ldap
        'enable_tls' => FALSE,
        'debug' => FALSE,
        'timeout' => 10,
        'port' => 636, # or 389 for non-ssl ldap
        'referrals' => FALSE,
        'attributes' => array('sAMAccountName', 'o', 'mail', 'userPrincipalName', 'givenName', 'sn', 'displayName', 'objectClass', 'description', 'telephoneNumber', 'distinguishedName', 'memberOf', 'proxyAddresses', 'homeDirectory', 'employeeID', 'employeeNumber', 'objectCategory'), #add and remove attributes as you see fit
        'dnpattern' => NULL,
        'search.enable' => TRUE,
        'search.base' => ['OU=your,DC=search,DC=dn'], # your AD/OPENLDAP search base
        'search.attributes' => array('mail'), # we search for mail attribute
        'search.username' => 'idp@example.org',
        'search.password' => 'examplepassword',
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


];
