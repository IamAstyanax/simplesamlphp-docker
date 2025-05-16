<?php
include 'saml20-idp-hosted-option_debug.php';
include 'saml20-idp-hosted-load_spinner.php';
include 'saml20-idp-hosted-function_needle_haystack.php';
include 'saml20-idp-hosted-die_check.php';
include 'attributes-injection-by-domain.php';

$metadata['https://your.idp.url.org/simplesaml/saml2/idp/metadata.php'] = [
    'host' => '__DEFAULT__',
    'privatekey' => 'ssp.pem',
    'certificate' => 'ssp.crt',
    'auth' => 'custom=multiauth', // Matches the key in authsources.php
    'userid.attribute' => 'mail',
    'signature.algorithm' => 'http://www.w3.org/2001/04/xmldsig-more#rsa-sha256',

    'authproc' => array(
        // Split the mail attribute - user@domain
        1 => array(
            'class' => 'core:ScopeFromAttribute',
            'sourceAttribute' => 'mail',
            'targetAttribute' => 'organization',
        ),
        // Source attributes from attributes-by-domain.php
        // Inject them into the user login flow//
        2 => [
            'class' => 'core:PHP',
            'code' => '
                // Load the attribute mapping file
                $attributeMap = include "/var/simplesamlphp/metadata/attributes-injection-by-domain.php";
                
                // Get the domain from the state (set by ScopeFromAttribute)
                $domain = $state["Attributes"]["organization"][0] ?? null;
                
                // If domain exists in the map, inject the attributes
                if ($domain && isset($attributeMap[$domain])) {
                    foreach ($attributeMap[$domain] as $key => $value) {
                        $state["Attributes"][$key] = [$value];
                    }
                } else {
                    // Optional: Log or handle missing domains
                    error_log("No attributes found for domain: " . $domain);
                }
            ',
        ],
        10 => array(
            'class' => 'core:PHP',
            'code' => 
                $option_debug .
                $load_spinner .
                $function_needle_haystack .
                $die_check,
        ),
    ),

];
