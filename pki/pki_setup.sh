#!/bin/bash

set -e
umask 077 # Files created by the script should not be accessible by others

# Check if an argument is provided
if [ -z "$1" ]; then
    echo "Please provide an argument: root, intermediate, leaf, or clean"
    exit 1
fi

if [ "$1" == "clean" ]; then
    # confirmation dialog
    read -n 1 -r -p "Are you sure you want to reset the PKI? (This will irrevocably delete all files) [y/N] "
    echo # (optional) move to a new line
    if [[ ! $REPLY =~ ^[Yy]$ ]]
    then
        echo "Reset cancelled"
        exit 1
    fi

    # remove all files in the output directory
    echo "Resetting PKI..."
    rm -rf output
fi

### ENVIRONMENT VARIABLES ###

LEAF_VALIDITY_DAYS=375
LEAF_DOMAIN_NAME="server.home"
ROOT_CA_VALIDITY_DAYS=7300 # 20 years
INTERMEDIATE_CA_VALIDITY_DAYS=3650 # 10 years

# Root CA
export ROOT_CA_DIR="output/root_ca"
ROOT_CA_KEY="root_ca.key"
ROOT_CA_CRT="root_ca.crt"
ROOT_CA_CSR="root_ca.csr" # not used
ROOT_CA_CONF="config/root_ca.conf"

# Intermediate CA 1
export INTERMEDIATE_CA_1_DIR="output/intermediate_ca_1"
INTERMEDIATE_CA_1_KEY="intermediate_ca_1.key"
INTERMEDIATE_CA_1_CRT="intermediate_ca_1.crt"
INTERMEDIATE_CA_1_CSR="intermediate_ca_1.csr"
INTERMEDIATE_CA_1_CHAIN="intermediate_ca_1_chain.crt"
INTERMEDIATE_CA_1_CONF="config/intermediate_ca_1.conf"

# Intermediate CA 2
export INTERMEDIATE_CA_2_DIR="output/intermediate_ca_2"
INTERMEDIATE_CA_2_KEY="intermediate_ca_2.key"
INTERMEDIATE_CA_2_CRT="intermediate_ca_2.crt"
INTERMEDIATE_CA_2_CSR="intermediate_ca_2.csr"
INTERMEDIATE_CA_2_CHAIN="intermediate_ca_2_chain.crt"
INTERMEDIATE_CA_2_CONF="config/intermediate_ca_2.conf"

# Leaf
export LEAF_SIGNING_DIR="output/intermediate_ca_2"
LEAF_SIGNING_CHAIN="output/intermediate_ca_2/intermediate_ca_2_chain.crt"
LEAF_SIGNING_CONF="config/intermediate_ca_2.conf"
###

if [ "$1" == "root" ]; then
    ###############
    ### ROOT CA ###
    ###############

    # Create the Root CA directory if it doesn't exist
    if [ -d "$ROOT_CA_DIR" ]; then
        echo "Root CA directory already exists" 
        exit 1
    fi

    # Create the directories and files
    mkdir -p ${ROOT_CA_DIR}/{certs,crl,newcerts,private}
    touch $ROOT_CA_DIR/index.txt
    echo 1000 > $ROOT_CA_DIR/serial
    echo 1000 > $ROOT_CA_DIR/crlnumber

    # Ask for passwords
    read -r -s -p "Enter the Root CA password: " ROOT_CA_PASSWORD
    echo
    if [[ -z "$ROOT_CA_PASSWORD" ]]; then
        echo "Root CA password cannot be empty"
        exit 1
    fi
    read -r -s -p "Enter the encryption password: " ENCRYPTION_PASSWORD
    echo
    if [[ -z "$ENCRYPTION_PASSWORD" ]]; then
        echo "Encryption password cannot be empty"
        exit 1
    fi

    # Encrypt the Root CA password
    echo "$ROOT_CA_PASSWORD" | openssl enc -aes-256-cbc -salt -pbkdf2 -k "$ENCRYPTION_PASSWORD" -iter 100000 -out $ROOT_CA_DIR/root_ca_password.enc

    # Generate the Root CA key
    openssl genrsa \
        -aes256 \
        -passout pass:"$ROOT_CA_PASSWORD" \
        -out $ROOT_CA_DIR/private/$ROOT_CA_KEY 4096

    # Generate the Root CA certificate
    openssl req \
        -config $ROOT_CA_CONF \
        -key $ROOT_CA_DIR/private/$ROOT_CA_KEY \
        -new \
        -x509 \
        -days $ROOT_CA_VALIDITY_DAYS \
        -sha256 \
        -extensions v3_ca \
        -passin pass:"$ROOT_CA_PASSWORD" \
        -out $ROOT_CA_DIR/$ROOT_CA_CRT

    # Verify the Root CA certificate
    openssl x509 \
        -noout \
        -text \
        -in $ROOT_CA_DIR/$ROOT_CA_CRT
fi

if [ "$1" == "intermediate" ]; then
    # Create the Intermediate CA 1 directory if it doesn't exist
    if [ -d "$INTERMEDIATE_CA_1_DIR" ]; then
        echo "Intermediate CA 1 directory already exists"
        exit 1
    fi

    # Ask for the Intermediate CA 1 password
    read -s -r -p "Enter the Intermediate CA 1 password: " INTERMEDIATE_CA_1_PASSWORD
    echo
    if [[ -z "$INTERMEDIATE_CA_1_PASSWORD" ]]; then
        echo "Intermediate CA 1 password cannot be empty"
        exit 1
    fi

    # Create the directories and files
    mkdir -p ${INTERMEDIATE_CA_1_DIR}/{certs,crl,csr,newcerts,private}
    touch $INTERMEDIATE_CA_1_DIR/index.txt
    echo 1000 > $INTERMEDIATE_CA_1_DIR/serial
    echo 1000 > $INTERMEDIATE_CA_1_DIR/crlnumber

    # Ask for passwords
    read -r -s -p "Enter the Root CA password: " ROOT_CA_PASSWORD
    echo
    if [[ -z "$ROOT_CA_PASSWORD" ]]; then
        echo "Root CA password cannot be empty"
        exit 1
    fi

    # Generate the Intermediate CA 1 key
    openssl genrsa \
        -aes256 \
        -passout pass:"$INTERMEDIATE_CA_1_PASSWORD" \
        -out $INTERMEDIATE_CA_1_DIR/private/$INTERMEDIATE_CA_1_KEY 4096

    # Generate the Intermediate CA 1 certificate
    openssl req \
        -config $INTERMEDIATE_CA_1_CONF \
        -new \
        -sha256 \
        -passin pass:"$INTERMEDIATE_CA_1_PASSWORD" \
        -key $INTERMEDIATE_CA_1_DIR/private/$INTERMEDIATE_CA_1_KEY \
        -out $INTERMEDIATE_CA_1_DIR/$INTERMEDIATE_CA_1_CSR

    # Sign the Intermediate CA 1 certificate with the Root CA
    openssl ca \
        -config $ROOT_CA_CONF \
        -extensions v3_intermediate_ca \
        -days $INTERMEDIATE_CA_VALIDITY_DAYS \
        -notext \
        -md sha256 \
        -passin pass:"$ROOT_CA_PASSWORD" \
        -in $INTERMEDIATE_CA_1_DIR/$INTERMEDIATE_CA_1_CSR \
        -out $INTERMEDIATE_CA_1_DIR/$INTERMEDIATE_CA_1_CRT

    # Verify the Intermediate CA 1 certificate
    openssl x509 \
        -noout \
        -text \
        -in $INTERMEDIATE_CA_1_DIR/$INTERMEDIATE_CA_1_CRT

    # Create the Intermediate CA 1 certificate chain
    cat $INTERMEDIATE_CA_1_DIR/$INTERMEDIATE_CA_1_CRT \
        $ROOT_CA_DIR/$ROOT_CA_CRT \
        > $INTERMEDIATE_CA_1_DIR/$INTERMEDIATE_CA_1_CHAIN

    # Verify the Intermediate CA 1 certificate chain
    openssl verify \
        -CAfile $INTERMEDIATE_CA_1_DIR/$INTERMEDIATE_CA_1_CHAIN \
        $INTERMEDIATE_CA_1_DIR/$INTERMEDIATE_CA_1_CRT

    #########################
    ### Intermediate CA 2 ###
    #########################

    # Create the Intermediate CA 2 directory if it doesn't exist
    if [ -d "$INTERMEDIATE_CA_2_DIR" ]; then
        echo "Intermediate CA 2 directory already exists"
        exit 1
    fi

    # Create the directories and files
    mkdir -p ${INTERMEDIATE_CA_2_DIR}/{certs,crl,csr,newcerts,private}
    touch $INTERMEDIATE_CA_2_DIR/index.txt
    echo 1000 > $INTERMEDIATE_CA_2_DIR/serial
    echo 1000 > $INTERMEDIATE_CA_2_DIR/crlnumber

    # Generate the Intermediate CA 2 key
    openssl genrsa \
        -out $INTERMEDIATE_CA_2_DIR/private/$INTERMEDIATE_CA_2_KEY 4096

    # Generate the Intermediate CA 2 certificate
    openssl req \
        -config $INTERMEDIATE_CA_2_CONF \
        -new \
        -sha256 \
        -key $INTERMEDIATE_CA_2_DIR/private/$INTERMEDIATE_CA_2_KEY \
        -out $INTERMEDIATE_CA_2_DIR/$INTERMEDIATE_CA_2_CSR

    # Sign the Intermediate CA 2 certificate with the Intermediate CA 1
    openssl ca \
        -config $INTERMEDIATE_CA_1_CONF \
        -extensions v3_intermediate_ca_2 \
        -days $INTERMEDIATE_CA_VALIDITY_DAYS \
        -notext \
        -md sha256 \
        -passin pass:"$INTERMEDIATE_CA_1_PASSWORD" \
        -in $INTERMEDIATE_CA_2_DIR/$INTERMEDIATE_CA_2_CSR \
        -out $INTERMEDIATE_CA_2_DIR/$INTERMEDIATE_CA_2_CRT

    # Create the certificate chain
    cat $INTERMEDIATE_CA_2_DIR/$INTERMEDIATE_CA_2_CRT $INTERMEDIATE_CA_1_DIR/$INTERMEDIATE_CA_1_CRT $ROOT_CA_DIR/$ROOT_CA_CRT > $INTERMEDIATE_CA_2_DIR/$INTERMEDIATE_CA_2_CHAIN

    # Verify the certificate chain
    openssl verify -CAfile $INTERMEDIATE_CA_2_DIR/$INTERMEDIATE_CA_2_CHAIN $INTERMEDIATE_CA_2_DIR/$INTERMEDIATE_CA_2_CRT

    # Verify the Intermediate CA 2 certificate
    openssl x509 \
        -noout \
        -text \
        -in $INTERMEDIATE_CA_2_DIR/$INTERMEDIATE_CA_2_CRT

    echo "PKI setup completed successfully"

    exit 0
fi


# Check if leaf argument is provided
if [ "$1" == "leaf" ]; then
    # check if ${LEAF_SIGNING_DIR} exists
    if [ ! -d ${LEAF_SIGNING_DIR} ]; then
        echo "${LEAF_SIGNING_DIR} does not exist. Exiting..."
        exit 1
    fi

    # check if ${LEAF_SIGNING_CHAIN} exists
    if [ ! -f ${LEAF_SIGNING_CHAIN} ]; then
        echo "${LEAF_SIGNING_CHAIN} does not exist. Exiting..."
        exit 1
    fi

    if [ ! -f config/${LEAF_DOMAIN_NAME}.conf ]; then
        echo "config/${LEAF_DOMAIN_NAME}.conf does not exist. Exiting..."
        exit 1
    fi

    # generate key
    openssl genpkey \
        -algorithm RSA \
        -out ${LEAF_SIGNING_DIR}/private/${LEAF_DOMAIN_NAME}.key

    chmod 400 ${LEAF_SIGNING_DIR}/private/${LEAF_DOMAIN_NAME}.key

    # Request
    openssl req \
        -config config/${LEAF_DOMAIN_NAME}.conf \
        -key ${LEAF_SIGNING_DIR}/private/${LEAF_DOMAIN_NAME}.key \
        -new -sha256 \
        -out ${LEAF_SIGNING_DIR}/csr/${LEAF_DOMAIN_NAME}.csr 

    # Sign
    openssl ca \
        -config ${LEAF_SIGNING_CONF} \
        -extensions server_cert \
        -days ${LEAF_VALIDITY_DAYS} \
        -notext \
        -md sha256 \
        -in ${LEAF_SIGNING_DIR}/csr/${LEAF_DOMAIN_NAME}.csr \
        -out ${LEAF_SIGNING_DIR}/certs/${LEAF_DOMAIN_NAME}.crt

    # Verify
    openssl x509 -noout -text \
        -in ${LEAF_SIGNING_DIR}/certs/${LEAF_DOMAIN_NAME}.crt

    echo "Leaf certificate setup completed successfully"
    exit 0
fi