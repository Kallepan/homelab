#!/bin/bash
export DOMAIN="CHANGEME"
openssl s_client -showcerts -connect ${DOMAIN}:443 -servername ${DOMAIN} < /dev/null 2>/dev/null | openssl x509 -outform PEM > ./${DOMAIN}.crt