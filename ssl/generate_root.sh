#!/bin/bash

# Step 1

### root ca ###
# generate key
openssl genrsa -passout file:pass.enc -out rootCA/private/ca.key.pem 4096
chmod 400 rootCA/private/ca.key.pem

# check
openssl rsa -noout -text -in rootCA/private/ca.key.pem

# generate ssl certificate
openssl req -config configs/openssl_root.cnf -key rootCA/private/ca.key.pem -new -x509 -days 7300 -sha256 -extensions v3_ca -out rootCA/certs/ca.cert.pem -subj "/C=DE/ST=NRW/L=Essen/O=Homelab/OU=Kalle/CN=Root CA"
chmod 444 rootCA/certs/ca.cert.pem

# check
openssl x509 -noout -text -in rootCA/certs/ca.cert.pem
