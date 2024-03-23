#!/bin/bash

### Variables ###
# Path to the kubeconfig file
KUBECONFIG=

# Name of the namespace to forward from
NAMESPACE=

# Name of the deployment to forward from
DEPLOYMENT=

# Name of the pod to forward from
POD=$(kubectl --kubeconfig=$KUBECONFIG get pods -n $NAMESPACE | grep $DEPLOYMENT | awk '{print $1}')

# Target port to forward from

TARGET_PORT=

# Local port to forward to
LOCAL_PORT=
### Variables ###


kubectl --kubeconfig=$KUBECONFIG port-forward -n $NAMESPACE pod/$POD $LOCAL_PORT:$TARGET_PORT
