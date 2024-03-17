#!/bin/bash 

# Create a secret for the GitLab Runner to use to connect to the GitLab server
# I used my intermediate CA certificate which I use to sign all my certificates in my srv-k8s.server.io domain
INTERMEDIATE_CA_CERTIFICATE_PATH=
k -n gitlab-runner create secret generic gitlab-runner-certs --from-file=gitlab.server.io.crt=${INTERMEDIATE_CA_CERTIFICATE_PATH}

# Create a secret for the GitLab Runner to use to connect to the GitLab server and registries
k -n gitlab-runner create secret generic gitlab-runner-ca-secret --from-file=ca.crt=${INTERMEDIATE_CA_CERTIFICATE_PATH}