#!/bin/bash

# This command must be run to bind the CA certificate for Vault
kubectl create secret generic vault-ca -nvault --from-file=ca.crt