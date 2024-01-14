#!/bin/bash

# Step 2.1

NAME=srv-docker-1

### intermediate ca ###
openssl genrsa -out customIntermediateCA/private/${NAME}.intermediate.key.pem 4096
chmod 400 customIntermediateCA/private/${NAME}.intermediate.key.pem

# CSR
openssl req -config configs/openssl_custom_intermediate.cnf -key  customIntermediateCA/private/${NAME}.intermediate.key.pem -new -sha256 -out customIntermediateCA/csr/${NAME}.intermediate.csr.pem -subj "/C=DE/ST=NRW/L=Essen/O=Homelab/OU=Kalle/CN=$NAME Secondary Intermediate CA"

# Sign with intermediateCA
openssl ca -config configs/openssl_intermediate.cnf -extensions v3_custom_intermediate_ca -days 3650 -notext -md sha256 -in customIntermediateCA/csr/${NAME}.intermediate.csr.pem -out customIntermediateCA/certs/${NAME}.intermediate.cert.pem
chmod 444 customIntermediateCA/certs/${NAME}.intermediate.cert.pem

# verify signatures
# I am not sure about -untrusted argument but it seems to correctly validate so, I guess it is fine?
openssl verify -CAfile rootCA/certs/ca.cert.pem -untrusted intermediateCA/certs/intermediate.cert.pem customIntermediateCA/certs/${NAME}.intermediate.cert.pem

# create bundled certificate
cat customIntermediateCA/certs/${NAME}.intermediate.cert.pem intermediateCA/certs/intermediate.cert.pem rootCA/certs/ca.cert.pem > customIntermediateCA/certs/${NAME}-ca-chain.cert.pem
openssl verify -CAfile customIntermediateCA/certs/${NAME}-ca-chain.cert.pem customIntermediateCA/certs/${NAME}.intermediate.cert.pem
