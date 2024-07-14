# Rancher

## Useful Tips and Tricks

### Validating webhook fails

If deleting the cattle-system is stuck in terminating state. You need to delete the `rancher.cattle.io` resource of type `Validatingwebhookconfigurations` to unblock the deletion of the namespace. Afterwards the finalizers can be removed from the namespace using `kubectl edit namespace cattle-system`.

```bash
alias k='sudo kubectl --kubeconfig=/etc/kubernetes/admin.conf'
k get validatingwebhookconfigurations -A
k delete validatingwebhookconfigurations <name>

k get namespace cattle-system -o json | jq '.spec.finalizers = []' | sudo kubectl --kubeconfig /etc/kubernetes/admin.conf replace --raw /api/v1/namespaces/cattle-system/finalize -f -
```

This was taken from [this](https://github.com/rancher/rancher/issues/41826#issuecomment-1633681415) issue.
