#!/bin/bash

DOMAIN_NAME=srv-kasm-1.server.io

# Step 3

# generate key
openssl genpkey -algorithm RSA -out intermediateCA/private/${DOMAIN_NAME}.key.pem
chmod 400 intermediateCA/private/${DOMAIN_NAME}.key.pem

# Adjust openssl_intermediate
sed -i '/^commonName_default/c\commonName_default = '${DOMAIN_NAME}'' configs/openssl_intermediate.cnf

# CSR
openssl req -config configs/openssl_intermediate.cnf -key intermediateCA/private/${DOMAIN_NAME}.key.pem -new -sha256 -out intermediateCA/csr/${DOMAIN_NAME}.csr.pem -batch

# Sign
openssl ca -config configs/openssl_intermediate.cnf -extfile configs/${DOMAIN_NAME}.cnf -extensions v3_req -days 375 -notext -md sha256 -in intermediateCA/csr/${DOMAIN_NAME}.csr.pem -out intermediateCA/certs/${DOMAIN_NAME}.cert.pem 
