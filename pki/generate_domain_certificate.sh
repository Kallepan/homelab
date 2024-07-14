#!/bin/bash

### sign certificate ###
set -e

# Variables
export DAYS=${1:-375}
export DOMAIN_NAME=${2:-"server.io"}

# Input files
export SIGNING_CA_DIR="./output/intermediate_ca_2"
export SIGNING_CA_CHAIN="${SIGNING_CA_DIR}/intermediate_ca_2_chain.crt"
export SIGNING_CA_CONF="config/intermediate_ca_2.conf"

# check if ${SIGNING_CA_DIR} exists
if [ ! -d ${SIGNING_CA_DIR} ]; then
    echo "${SIGNING_CA_DIR} does not exist. Exiting..."
    exit 1
fi

# check if ${SIGNING_CA_CHAIN} exists
if [ ! -f ${SIGNING_CA_CHAIN} ]; then
    echo "${SIGNING_CA_CHAIN} does not exist. Exiting..."
    exit 1
fi

if [ ! -f config/${DOMAIN_NAME}.conf ]; then
    echo "config/${DOMAIN_NAME}.conf does not exist. Exiting..."
    exit 1
fi

# generate key
openssl genpkey \
    -algorithm RSA \
    -out ${SIGNING_CA_DIR}/private/${DOMAIN_NAME}.key

chmod 400 ${SIGNING_CA_DIR}/private/${DOMAIN_NAME}.key

# Request
openssl req \
    -config config/${DOMAIN_NAME}.conf \
    -key ${SIGNING_CA_DIR}/private/${DOMAIN_NAME}.key \
    -new -sha256 \
    -out ${SIGNING_CA_DIR}/csr/${DOMAIN_NAME}.csr 

# Sign
openssl ca \
    -config ${SIGNING_CA_CONF} \
    -extensions server_cert \
    -days ${DAYS} \
    -notext \
    -md sha256 \
    -in ${SIGNING_CA_DIR}/csr/${DOMAIN_NAME}.csr \
    -out ${SIGNING_CA_DIR}/certs/${DOMAIN_NAME}.crt

# Verify
openssl x509 -noout -text \
    -in ${SIGNING_CA_DIR}/certs/${DOMAIN_NAME}.crt