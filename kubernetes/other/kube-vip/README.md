# Kube vip

## Overview

This files was generated using the ansible setup [role for kuberntetes](/ansible/roles/kubernetes/tasks/kube_vip.yml). The role is used to setup the kube-vip static pod for the kubernetes cluster.

## Notes

Note the usage of super-admin.conf instead of admin.conf. This is because of a change in kubernetes 1.29. This is a temporary fix until the issue is resolved i.e. kube-vip offers a better solution.
