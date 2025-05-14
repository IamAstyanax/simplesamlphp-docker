#!/bin/bash

## Generate Certs

# Set certificate details
DOMAIN="simplesaml.local"
DAYS_VALID=1825
CERT_DIR="./container_files"
KEY_FILE="${CERT_DIR}/${DOMAIN}.key"
CERT_FILE="${CERT_DIR}/${DOMAIN}.crt"

# Create output directory if it doesn't exist
mkdir -p "$CERT_DIR"

# Generate private key and certificate
openssl req -x509 -nodes -newkey rsa:4096 \
  -keyout "$KEY_FILE" \
  -out "$CERT_FILE" \
  -days "$DAYS_VALID" \
  -subj "/C=US/ST=State/L=City/O=Organization/CN=$DOMAIN"

echo "Self-signed certificate and key have been created:"
echo "  Certificate: $CERT_FILE"
echo "  Key:         $KEY_FILE"

cp  $KEY_FILE "./container_files/private/ssp.key"
cp  $KEY_FILE "./container_files/certs/ssp.key"
cp  $CERT_FILE "./container_files/certs/ssp.crt"
rm $KEY_FILE
rm $CERT_FILE

docker build -t astyanax-simplesamlphp .

docker-compose up -d