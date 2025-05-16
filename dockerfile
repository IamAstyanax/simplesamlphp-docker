FROM debian:12

# Define SSP version
ARG SSP_VERSION=2.4.0

ARG DEBIAN_FRONTEND=noninteractive

#ARG CONFIG_BASEURLPATH=simplesaml/
ARG CONFIG_AUTHADMINPASSWORD_ARG=YourAdminPassword
ARG CONFIG_SECRETSALT_ARG=YourSecretSalt
ARG CONFIG_TECHNICALCONTACT_NAME_ARG=YourTechnicalContact
ARG CONFIG_TECHNICALCONTACT_EMAIL_ARG=YourTechnicalEmail
ARG CONFIG_SHOWERRORS_ARG=false
ARG CONFIG_ERRORREPORTING_ARG=true
ARG CONFIG_ADMINPROTECTINDEXPAGE_ARG=true
ARG CONFIG_ADMINPROTECTMETADATA_ARG=false
ARG CONFIG_PRODUCTION_ARG=true
ARG CONFIG_LOGGINGLEVEL_ARG=INFO
ARG CONFIG_LOGGINGHANDLER_ARG=file
ARG CONFIG_ENABLESAML20IDP_ARG=true
ARG CONFIG_TIMEZONE=America/Chicago
ARG CONFIG_SIMPLESAMLPHPURL=idp.srv.private


# Environment Variables
#ENV CONFIG_BASEURLPATH=$CONFIG_BASEURLPATH_ARG
ENV CONFIG_AUTHADMINPASSWORD=$CONFIG_AUTHADMINPASSWORD_ARG
ENV CONFIG_SECRETSALT=$CONFIG_SECRETSALT_ARG
ENV CONFIG_TECHNICALCONTACT_NAME=$CONFIG_TECHNICALCONTACT_NAME_ARG
ENV CONFIG_TECHNICALCONTACT_EMAIL=$CONFIG_TECHNICALCONTACT_EMAIL_ARG
ENV CONFIG_SHOWERRORS=$CONFIG_SHOWERRORS_ARG
ENV CONFIG_ERRORREPORTING=$CONFIG_ERRORREPORTING_ARG
ENV CONFIG_ADMINPROTECTINDEXPAGE=$CONFIG_ADMINPROTECTINDEXPAGE_ARG
ENV CONFIG_ADMINPROTECTMETADATA=$CONFIG_ADMINPROTECTMETADATA_ARG
ENV CONFIG_PRODUCTION=$CONFIG_PRODUCTION_ARG
ENV CONFIG_LOGGINGLEVEL=$CONFIG_LOGGINGLEVEL_ARG
ENV CONFIG_LOGGINGHANDLER=$CONFIG_LOGGINGHANDLER_ARG
ENV CONFIG_ENABLESAML20IDP=$CONFIG_ENABLESAML20IDP_ARG
ENV CONFIG_THEMEUSE=$CONFIG_THEMEUSE_ARG
ENV CONFIG_STORETYPE=$CONFIG_STORETYPE_ARG
ENV CONFIG_MEMCACHESTOREPREFIX=$CONFIG_MEMCACHESTOREPREFIX_ARG
ENV CONFIG_MEMCACHESTORESERVERS=$CONFIG_MEMCACHESTORESERVERS_ARG
ENV OPENLDAP_TLS_REQCERT=$OPENLDAP_TLS_REQCERT_ARG
ENV WWW_INDEX=$WWW_INDEX_ARG
ENV MTA_NULLCLIENT=$MTA_NULLCLIENT_ARG
ENV POSTFIX_MYHOSTNAME=$POSTFIX_MYHOSTNAME_ARG
ENV POSTFIX_MYORIGIN=$POSTFIX_MYORIGIN_ARG
ENV POSTFIX_INETINTERFACES=$POSTFIX_INETINTERFACES_ARG
ENV POSTFIX_MYDESTINATION=$POSTFIX_MYDESTINATION_ARG
ENV DOCKER_REDIRECTLOGS=$DOCKER_REDIRECTLOGS_ARG
ENV WWW_INDEX=$WWW_INDEX_ARG
ENV CONFIG_TIMEZONE=$CONFIG_TIMEZONE
ENV SSP_VERSION=$SSP_VERSION
ENV CONFIG_SIMPLESAMLPHPURL=$SIMPLESAMLPHPURL

# Install dependencies
RUN apt-get update && \
    apt-get install -y curl gnupg2 ca-certificates lsb-release apt-transport-https

RUN curl -fsSL https://packages.sury.org/php/apt.gpg | gpg --dearmor -o /usr/share/keyrings/php.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/php.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list && \
    apt-get update


# Install necessary packages
RUN apt-get install -y \
    php8.2 \
    php8.2-cli \
    php8.2-fpm \
    php8.2-mysql \
    php8.2-zip \
    php8.2-gd \
    php8.2-mbstring \
    php8.2-curl \
    php8.2-bcmath \
    php8.2-xml \
    php-pear \
    php8.2-memcached \
    php8.2-ldap \
    php8.2-memcache \
    php8.2-sqlite3 \
    nginx \
    supervisor \
    vim && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN echo ${SSP_VERSION}
# Pull and extract SSP from repo
# Download using curl
RUN curl -fsSL -o simplesamlphp-${SSP_VERSION}.tar.gz https://github.com/simplesamlphp/simplesamlphp/releases/download/v${SSP_VERSION}/simplesamlphp-${SSP_VERSION}-full.tar.gz

# Extract to /var and rename
RUN tar xzf simplesamlphp-${SSP_VERSION}.tar.gz -C /var && \
    mv /var/simplesamlphp-${SSP_VERSION} /var/simplesamlphp

# Copy custom container files into /var/simplesaml/php
COPY ./container_files/simplesamlphp /var/simplesamlphp

# Set working dir and build with composer
WORKDIR /var/simplesamlphp
RUN composer install
RUN composer require symfony/ldap:7.2
RUN composer require simplesamlphp/simplesamlphp-module-ldap:2.4.6

# Permissions and cache dirs for ssp
RUN mkdir -p /var/simplesamlphp/log && \
    chown -R www-data:www-data /var/simplesamlphp && \
    mkdir -p /var/cache/simplesamlphp/core /var/cache/simplesamlphp/admin && \
    chown -R www-data:www-data /var/cache/simplesamlphp /var/simplesamlphp/log

# Copy necessary items over
COPY ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY ./container_files/nginx /etc/nginx
COPY ./container_files/certs /etc/pki/tls/certs
COPY ./container_files/private /etc/pki/tls/private
COPY ./container_files/certs /var/simplesamlphp/cert
COPY ./container_files/cont-init.d /etc/cont-init.d

EXPOSE 80

CMD ["supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
