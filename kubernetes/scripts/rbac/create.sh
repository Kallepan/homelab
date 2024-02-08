#!/bin/bash

#### Variables ####
NAMESPACE=mibi
SERVICE_ACCOUNT=mibi
SECRET_NAME=${SERVICE_ACCOUNT}-token

# Target cluster 
SERVER=https://192.168.21.137:6443

# Path to kubeconfigs
ADMIN_KUBE_CONFIG=/Users/kalle/.kube/dev.yaml
OUTPUT_KUBE_CONFIG=/Users/kalle/.kube/mibi.yaml
#### End Variables ####

# Fetch variables from the admin kubeconfig
CLUSTER_NAME=$(kubectl --kubeconfig=$ADMIN_KUBE_CONFIG config view -o jsonpath='{.clusters[0].name}')

# Create the namespace
kubectl create namespace $NAMESPACE --kubeconfig=$ADMIN_KUBE_CONFIG

set -o errexit

# Apply the service account
echo "
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: ${SERVICE_ACCOUNT}
  namespace: ${NAMESPACE}
  annotations:
    kubernetes.io/enforce-mountable-secrets: 'true'
secrets:
  - name: ${SECRET_NAME}
" | kubectl apply --kubeconfig=$ADMIN_KUBE_CONFIG -f -

# Apply the tokenrequest
echo "
apiVersion: v1
kind: Secret
metadata:
  name: ${SECRET_NAME}
  namespace: ${NAMESPACE}
  annotations:
    kubernetes.io/service-account.name: ${SERVICE_ACCOUNT}
type: kubernetes.io/service-account-token
" | kubectl apply --kubeconfig=$ADMIN_KUBE_CONFIG -f -

### Replacements ###
# use sed to replace the namespace 
sed -i '' "s/namespace: default/namespace: $NAMESPACE/g" role.yaml
# use sed to replace the role name
sed -i '' "s/name: default/name: $SERVICE_ACCOUNT/g" role.yaml
### End Replacements ###

sed -i '' "s/
# Create the role using role.yaml
kubectl --kubeconfig=$ADMIN_KUBE_CONFIG apply -f role.yaml

# Apply the binding
echo "
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: ${SERVICE_ACCOUNT}-rolebinding
  namespace: ${NAMESPACE}
subjects:
- kind: ServiceAccount
  name: ${SERVICE_ACCOUNT}
roleRef:
  kind: Role
  name: ${SERVICE_ACCOUNT}-role
  apiGroup: rbac.authorization.k8s.io
" | kubectl apply --kubeconfig=$ADMIN_KUBE_CONFIG -f -


ca=$(kubectl --kubeconfig=$ADMIN_KUBE_CONFIG get secret -n $NAMESPACE $SECRET_NAME -o jsonpath='{.data.ca\.crt}')
token=$(kubectl --kubeconfig=$ADMIN_KUBE_CONFIG -n $NAMESPACE get secret/"$SECRET_NAME" -o=jsonpath='{.data.token}' | base64 --decode)

# Generate the kubeconfig file
echo "
---
apiVersion: v1
kind: Config
clusters:
  - name: ${CLUSTER_NAME}
    cluster:
      server: ${SERVER}
      certificate-authority-data: "$ca"
contexts:
  - name: ${SERVICE_ACCOUNT}@${CLUSTER_NAME}
    context:
      cluster: ${CLUSTER_NAME}
      namespace: ${NAMESPACE}
      user: ${SERVICE_ACCOUNT}
users:
  - name: ${SERVICE_ACCOUNT}
    user:
      token: ${token}
current-context: ${SERVICE_ACCOUNT}@${CLUSTER_NAME}
" | tee $OUTPUT_KUBE_CONFIG