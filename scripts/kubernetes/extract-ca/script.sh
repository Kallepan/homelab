#!/bin/bash

# Define the source CA and key
SOURCE_CA=certs/
SOURCE_KEY=private/

# Encode the CA and key
ENCODED_CA=$(cat $SOURCE_CA | base64 -w 0)
ENCODED_KEY=$(cat $SOURCE_KEY | base64 -w 0)

# Create kubernetes secret
echo "apiVersion: v1
kind: Secret
metadata:
  name: ca-secret
  namespace: cert-manager
type: Opaque
data:
  tls.crt: $ENCODED_CA
  tls.key: $ENCODED_KEY" 