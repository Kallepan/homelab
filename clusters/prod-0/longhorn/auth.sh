#!/bin/bash

USER=<USERNAME_HERE>; PASSWORD=<PASSWORD_HERE>; echo "${USER}:$(openssl passwd -stdin -apr1 <<< ${PASSWORD})" >> auth
kubectl create secret generic basic-auth --from-file=auth --namespace longhorn-system