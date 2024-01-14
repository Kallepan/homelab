# CA 

Scripts to generate ssl certificates and own CA. Probably should not be used in production :D.

## Source

Adapted from [here](https://www.golinuxcloud.com/openssl-create-certificate-chain-linux/#Step_6_Generate_and_sign_server_certificate_using_Intermediate_CA).

## Generate Server (Leaf) Certificates

0. Add the domain to the [SAN](ca/configs/openssl_intermediate.cnf) section of the intermediate config file.

1. Change the $NAME variable in [generate_server_certificate.sh](generate_server_certificate.sh) to the desired name.

2. Add .cnf file to [configs](ca/configs) folder with the same name as $NAME variable (use [this](ca/configs/pfsense.server.io.cnf) for an example).

3. Run the script:

```bash
./generate_server_certificate.sh
```

## Generate CA

Configs are found within the [configs](ca/configs) folder.

0. [reset.sh](ca/reset.sh)
    - Creates the necessary files and folders
    - E.g.:
        - folders: certs, crl, newcerts, private, and cs
        - files: index.txt, serial, and crlnumber
1. [generate_root.sh](ca/generate_root.sh)
    - generates a root certificate using [this](ca/configs/openssl_root.cnf) config file
2. [generate_intermediate.sh](ca/generate_intermediate.sh)
    - generates an intermediate certificate using [this](ca/configs/openssl_intermediate.cnf) config file.
3. [generate_custom_intermediate.sh](ca/generate_custom_intermediate.sh) 
    - optional step to create a second intermediary CA. Useful for software which requires its own CA.
    - Simply change the $NAME variable to any desired value
    - create a .cnf file in [configs](ca/configs) folder with the same name as $NAME.domain.com.cnf
4. [generate_server_certificate.sh](generate_server_certificate.sh)
    - request a leaf certificate using the .cnf [configs](ca/configs) file defined as $NAME variable (use [this](ca/configs/pfsense.server.io.cnf) for an example).