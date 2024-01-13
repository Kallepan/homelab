#!/bin/bash

# Reset

# rootCA
rm rootCA -rf

mkdir -p rootCA/{certs,crl,newcerts,private,csr}
touch rootCA/index.txt
echo 1000 > rootCA/serial
echo 0100 > rootCA/crlnumber

# intermediate CA
rm intermediateCA -rf

mkdir -p intermediateCA/{certs,crl,newcerts,private,csr}
touch intermediateCA/index.txt
echo 1000 > intermediateCA/serial
echo 0100 > intermediateCA/crlnumber

# secondary intermediate CA
rm customIntermediateCA -rf

mkdir -p customIntermediateCA/{certs,crl,newcerts,private,csr}
touch customIntermediateCA/index.txt
echo 1000 > customIntermediateCA/serial
echo 0100 > customIntermediateCA/crlnumber
