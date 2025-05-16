#!/bin/bash
echo "Configuring SimpleSAMLPHP"
chown -R www-data:www-data /var/simplesamlphp/cert/ssp.pem
# #Apply Configurations
#sed -i "s|'baseurlpath' => 'simplesaml/'|'baseurlpath' => '$CONFIG_BASEURLPATH'|g" /var/simplesamlphp/config/config.php

sed -i "s|'auth.adminpassword' => 'yeet'|'auth.adminpassword' => '$CONFIG_AUTHADMINPASSWORD'|g" /var/simplesamlphp/config/config.php
sed -i "s|'secretsalt' => 'defaultsecretsalt'|'secretsalt' => '${CONFIG_SECRETSALT}'|g" /var/simplesamlphp/config/config.php
sed -i "s|'technicalcontact_name' => 'Administrator'|'technicalcontact_name' => '$CONFIG_TECHNICALCONTACT_NAME'|g" /var/simplesamlphp/config/config.php
sed -i "s|'technicalcontact_email' => 'na@example.org'|'technicalcontact_email' => '$CONFIG_TECHNICALCONTACT_EMAIL'|g" /var/simplesamlphp/config/config.php
# sed -i "s|'language.default' => 'en'|'language.default' => '$CONFIG_LANGUAGEDEFAULT'|g" /var/simplesamlphp/config/config.php
sed -i "s|'timezone' => null|'timezone' => '$CONFIG_TIMEZONE'|g" /var/simplesamlphp/config/config.php
sed -i "s|'your.idp.url.org'|'$SIMPLESAMLPHPURL'|g" /var/simplesamlphp/metadata/saml20-idp-hosted.php

# sed -i "s|'tempdir' => '/tmp/simplesaml'|'tempdir' => '$CONFIG_TEMPDIR'|g" /var/simplesamlphp/config/config.php
# sed -i "s|'showerrors' => true|'showerrors' => $CONFIG_SHOWERRORS|g" /var/simplesamlphp/config/config.php
# sed -i "s|'errorreporting' => true|'errorreporting' => $CONFIG_ERRORREPORTING|g" /var/simplesamlphp/config/config.php
sed -i "s|'admin.protectindexpage' => false|'admin.protectindexpage' => $CONFIG_ADMINPROTECTINDEXPAGE|g" /var/simplesamlphp/config/config.php
sed -i "s|'admin.protectmetadata' => false|'admin.protectmetadata' => $CONFIG_ADMINPROTECTMETADATA|g" /var/simplesamlphp/config/config.php
sed -i "s|'production' => true,|'production' => $CONFIG_PRODUCTION,|g" /var/simplesamlphp/config/config.php

# sed -i "s|'debug' => false|'debug' => $CONFIG_DEBUG|g" /var/simplesamlphp/config/config.php
# sed -i "s|'logging.level' => SimpleSAML_Logger::NOTICE|'logging.level' => SimpleSAML_Logger::$CONFIG_LOGGINGLEVEL|g" /var/simplesamlphp/config/config.php
# sed -i "s|'logging.handler' => 'syslog'|'logging.handler' => '$CONFIG_LOGGINGHANDLER'|g" /var/simplesamlphp/config/config.php
# sed -i "s|'logging.logfile' => 'simplesamlphp.log'|'logging.logfile' => '$CONFIG_LOGFILE'|g" /var/simplesamlphp/config/config.php

sed -i "s|'enable.saml20-idp' => false|'enable.saml20-idp' => $CONFIG_ENABLESAML20IDP|g" /var/simplesamlphp/config/config.php
# sed -i "s|'enable.shib13-idp' => false|'enable.shib13-idp' => $CONFIG_ENABLESHIB13IDP|g" /var/simplesamlphp/config/config.php
# sed -i "s|'enable.adfs-idp' => false|'enable.adfs-idp' => $CONFIG_ENABLEADFSIDP|g" /var/simplesamlphp/config/config.php
# sed -i "s|'enable.wsfed-sp' => false|'enable.wsfed-sp' => $CONFIG_ENABLEWSFEDSP|g" /var/simplesamlphp/config/config.php
# sed -i "s|'enable.authmemcookie' => false|'enable.authmemcookie' => $CONFIG_ENABLEAUTHMEMCOOKIE|g" /var/simplesamlphp/config/config.php

# sed -i "s|'session.duration' => 8 \* (60 \* 60)|'session.duration' => $CONFIG_SESSIONDURATION|g" /var/simplesamlphp/config/config.php
# sed -i "s|'session.datastore.timeout' => (4 \* 60 \* 60)|'session.datastore.timeout' => $CONFIG_SESSIONDATASTORETIMEOUT|g" /var/simplesamlphp/config/config.php
# sed -i "s|'session.state.timeout' => (60 \* 60)|'session.state.timeout' => $CONFIG_SESSIONSTATETIMEOUT|g" /var/simplesamlphp/config/config.php
# sed -i "s|'session.cookie.lifetime' => 0|'session.cookie.lifetime' => $CONFIG_SESSIONCOOKIELIFETIME|g" /var/simplesamlphp/config/config.php

# sed -i "s|'session.phpsession.cookiename' => 'SimpleSAML'|'session.phpsession.cookiename' => '$CONFIG_SESSIONPHPSESSIONCOOKIENAME'|g" /var/simplesamlphp/config/config.php
# sed -i "s|'session.phpsession.savepath' => null|'session.phpsession.savepath' => '$CONFIG_SESSIONPHPSESSIONSAVEPATH'|g" /var/simplesamlphp/config/config.php
# sed -i "s|'session.phpsession.httponly' => true|'session.phpsession.httponly' => $CONFIG_SESSIONPHPSESSIONHTTPONLY|g" /var/simplesamlphp/config/config.php

# sed -i "s|'session.rememberme.enable' => false|'session.rememberme.enable' => $CONFIG_SESSIONREMEMBERMEENABLE|g" /var/simplesamlphp/config/config.php
# sed -i "s|'session.rememberme.checked' => false|'session.rememberme.checked' => $CONFIG_SESSIONREMEMBERMECHECKED|g" /var/simplesamlphp/config/config.php
# sed -i "s|'session.rememberme.lifetime' => (14 \* 86400)|'session.rememberme.lifetime' => $CONFIG_SESSIONREMEMBERMELIFETIME|g" /var/simplesamlphp/config/config.php

# sed -i "s|'session.cookie.secure' => false|'session.cookie.secure' => $CONFIG_SESSIONCOOKIESECURE|g" /var/simplesamlphp/config/config.php
# sed -i "s|'enable.http_post' => false|'enable.http_post' => $CONFIG_ENABLEHTTPPOST|g" /var/simplesamlphp/config/config.php

# sed -i "s|'theme.use' => 'default'|'theme.use' => '$CONFIG_THEMEUSE'|g" /var/simplesamlphp/config/config.php

