#!/bin/bash

kubectl create configmap ca-chain --from-file=ca-chain.cert.pem -n uptime-kuma