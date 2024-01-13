# Cert Manager Cheatsheet

## Secrets

- Convert the generated key and ca to base64 by running:

```bash
cat ca.crt | base64 -w 0
cat ca.key | base64 -w 0
```

- paste the info in here:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: ca-secret
  namespace: cert-manager
type: Opaque
data:
  tls.crt:  # content of ca.crt (converted to base64)
  tls.key:  # content of ca.key (converted to base64)
```

## ClusterIssuer

```yaml
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: cluster-issuer
spec:
  ca:
    secretName: ca-secret
```

## Create Certificates

### cert.yaml

```yaml
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: changeme-cert
  namespace: changeme
spec:
  secretName: changeme-tls-secret
  issuerRef:
    name: cluster-issuer
    kind: ClusterIssuer
  dnsNames:
    - changeme.srv-k8s.server.home
```

### ingressroute.yaml

- Add this to the bottom

```yaml
  tls:
    secretName: changeme-tls-secret
```
