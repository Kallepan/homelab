#!/bin/bash
# Script to port forward a port on a pod to the hostport

PORT_POD=5432
NS=TEST
PODNAME=TEST2

kubectl port-forward -n $NS pods/${PODNAME} 30000:$PORT_POD
