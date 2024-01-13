#!/bin/bash

# Step 2

### intermediate ca ###
openssl genrsa -out intermediateCA/private/intermediate.key.pem 4096
chmod 400 intermediateCA/private/intermediate.key.pem

# CSR
openssl req -config configs/openssl_intermediate.cnf -key  intermediateCA/private/intermediate.key.pem -new -sha256 -out intermediateCA/csr/intermediate.csr.pem -subj "/C=DE/ST=NRW/L=Essen/O=Homelab/OU=Kalle/CN=Intermediate CA"

# Sign with rootCA
openssl ca -config configs/openssl_root.cnf -extensions v3_intermediate_ca -days 3650 -notext -md sha256 -in intermediateCA/csr/intermediate.csr.pem -out intermediateCA/certs/intermediate.cert.pem
chmod 444 intermediateCA/certs/intermediate.cert.pem

# verify signatures
openssl verify -CAfile rootCA/certs/ca.cert.pem intermediateCA/certs/intermediate.cert.pem

# create bundle
cat intermediateCA/certs/intermediate.cert.pem rootCA/certs/ca.cert.pem > intermediateCA/certs/ca-chain.cert.pem

# verify
openssl verify -CAfile intermediateCA/certs/ca-chain.cert.pem intermediateCA/certs/intermediate.cert.pem

