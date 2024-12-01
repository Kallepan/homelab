# Public Key Infrastructure (PKI) Script

## Overview

This script automates the setup of a basic Public Key Infrastructure (PKI) with a Root Certificate Authority (CA) and two Intermediate CAs. The Root CA is the top-level CA that signs the Intermediate CA certificates, which can then be used to sign end-entity certificates or further intermediate CAs. The script uses `openssl` to generate keys and certificates and to set up the necessary directory structure.

## Features

- **Root CA**: Creates a Root CA with a self-signed certificate, valid for 20 years.
- **Intermediate CA 1**: Creates an Intermediate CA, signed by the Root CA, valid for 10 years.
- **Intermediate CA 2**: Creates a second Intermediate CA, signed by Intermediate CA 1, valid for 10 years.
- **Security**: Passwords are required for CA key generation, and the Root CA password is encrypted with AES-256-CBC.

## Prerequisites

- OpenSSL installed on your system.
- Basic knowledge of PKI and certificate management.

## Directory Structure

The script creates the following directory structure:

```bash
output/
├── root_ca/
│   ├── certs/
│   ├── crl/
│   ├── newcerts/
│   ├── private/
│   ├── root_ca.key
│   ├── root_ca.crt
│   ├── root_ca.csr
│   ├── root_ca_password.enc
│   └── index.txt
├── intermediate_ca_1/
│   ├── certs/
│   ├── crl/
│   ├── csr/
│   ├── newcerts/
│   ├── private/
│   ├── intermediate_ca_1.key
│   ├── intermediate_ca_1.crt
│   ├── intermediate_ca_1.csr
│   ├── intermediate_ca_1_chain.crt
│   └── index.txt
└── intermediate_ca_2/
    ├── certs/
    ├── crl/
    ├── csr/
    ├── newcerts/
    ├── private/
    ├── intermediate_ca_2.key
    ├── intermediate_ca_2.crt
    ├── intermediate_ca_2.csr
    ├── intermediate_ca_2_chain.crt
    └── index.txt
```

## Usage

### Step 1: Configure the CAs

Before running the script, ensure that the following configuration files are present:

- `config/root_ca.conf`
- `config/intermediate_ca_1.conf`
- `config/intermediate_ca_2.conf`

These configuration files should contain the necessary OpenSSL settings for generating the certificates.

### Step 2: Run the Script

Execute the script with:

```bash
# To generate the Root CA and Intermediate CAs:
./pki_setup.sh basic

# To generate leaf certificates signed by the Intermediate CAs:
./pki_setup.sh leaf

# To clean up the output directory:
./pki_setup.sh clean
```

### Step 3: Follow Prompts

You will be prompted to enter passwords for the Root CA and Intermediate CAs. The Root CA password will be encrypted and stored in `root_ca_password.enc`.

### Step 4: Verify the Certificates

The script automatically verifies each certificate and its corresponding chain:

- **Root CA**: Self-signed.
- **Intermediate CA 1**: Signed by the Root CA.
- **Intermediate CA 2**: Signed by Intermediate CA 1.

## Security Considerations

- **Password Management**: Ensure that the encryption and Root CA passwords are stored securely.
- **Directory Permissions**: The script sets strict permissions to prevent unauthorized access to sensitive files.

## License

This script is provided "as is" without warranty of any kind. Use at your own risk.

---

By following these instructions, you can set up a basic PKI environment to manage your own certificates and keys. For more complex PKI setups, consider expanding the script with additional features like revocation lists or multiple intermediate CAs.
