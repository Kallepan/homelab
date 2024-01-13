# KASM

## Description

Kasm is a containerized browser streaming solution. It allows users to access a full desktop environment from within a web browser. Kasm is built on top of [Apache Guacamole](https://guacamole.apache.org/). A detailed overview on how to install along with the requirements can be found [here](https://www.kasmweb.com/docs/latest/install/single_server_install.html).

## Deployment
```bash
# Move to the tmp directory
cd /tmp

# Download KASM
curl -O https://kasm-static-content.s3.amazonaws.com/kasm_release_1.14.0.3a7abb.tar.gz
tar -xf kasm_release_1.14.0.3a7abb.tar.gz

# Install KASM
sudo bash kasm_release/install.sh
```