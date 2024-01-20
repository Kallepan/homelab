#!/bin/bash

# Test with dummy self signed
openssl genrsa -out ca.key 4096
openssl req -new -x509 -sha256 -days 3650 -key ca.key -out ca.crt

cat ca.crt | base64 -w 0
cat ca.key | base64 -w 0

# Alternatively the intermediate CA can be used which is present in the ssl folder of this repo.
# See: ssl/customIntermediateCA/certs/ca-chain.cert.pem and ssl/customIntermediateCA/private/ca-chain.key.pem