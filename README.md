## SimpleSAMLPHP in Docker
SimpleSAMLPHP in docker. Based on debian 12 base image, supervisord, PHP8.2, nginx, and SimpleSAMLPHP 2.4.0.

## Features and container options
1. Custom email address driven multiauth.
2. Attribute injection using PHP instead of scoping LDAP attributes.


## How to build

# Generate Self Signed Certificate and Key
openssl req -x509 -nodes -newkey rsa:2048 \
  -keyout ./container_files/certs/ssp.key \
  -out ./container_files/certs/ssp.crt \
  -days 365 \
  -subj "/C=US/ST=State/L=City/O=Organization/CN=yourdomain.com"

## Environment Variables


## Starting the container

