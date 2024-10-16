#!/bin/bash

#
# Fetches all namespaces that are not associated with a profile
#

# Fetch all profiles
profiles=$(kubectl --kubeconfig ~/Downloads/gpu.yaml get profiles -o jsonpath='{.items[*].metadata.name}')

# Fetch all namespaces
namespaces=$(kubectl --kubeconfig ~/Downloads/gpu.yaml get ns -o jsonpath='{.items[*].metadata.name}')

# Filter out the namespaces that match the profiles
system_namespaces=()
for ns in $namespaces; do
    matched=false

    for profile in ${profiles[@]}; do
        if [[ $ns == *$profile* ]]; then
            matched=true
            break
        fi
    done

    if [ $matched == false ]; then
        system_namespaces+=($ns)
    fi
done

# Print the system namespaces
for ns in ${system_namespaces[@]}; do
  echo $ns
done
