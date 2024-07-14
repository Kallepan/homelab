# Flux CICD

Init command

```bash
flux bootstrap git --url=ssh://git@github.com/kallepan/homelab.git --branch=main --private-key-file=keys/github_key --path=cicd/prod --kubeconfig=terraform/prod/files/kubeconfig.yaml
```
