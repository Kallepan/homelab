#!/bin/bash

# This script tests the ssl certificate of a target url

TARGET_URL=https://www.google.de

curl --insecure -vvI $TARGET_URL 2>&1 | awk 'BEGIN { cert=0 } /^\* SSL connection/ { cert=1 } /^\*/ { if (cert) print }'
