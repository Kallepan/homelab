# Self Signed Certs

## 1. Setup OpenSSL

- Update and Install necessary packages

```bash
sudo apt update && sudo apt install openssl
```

## 2. Create Private Key

- First, we'll create a private key. A private key helps to enable encryption, and is the most important component of our certificate.

```bash
openssl genrsa -out domain.key 2048
```

## 3. Creating a Certificate Signing Request

- If we want our certificate signed, we need a certificate signing request (CSR). The CSR includes the public key and some additional information (such as organization and country).
- An important field is “Common Name,” which should be the exact Fully Qualified Domain Name (FQDN) of our domain.

```bash
openssl req -key domain.key -new -out domain.csr
```

## 4. Creating a Self-Signed Certificate

### Do not do this. Instead go ot 5

- A self-signed certificate is a certificate that's signed with its own private key. It can be used to encrypt data just as well as CA-signed certificates, but our users will be shown a warning that says the certificate isn't trusted.

```bash
openssl x509 -signkey domain.key -in domain.csr -req -days 365 -out domain.crt
```

## 5. Creating a CA-Signed Certificate With Our Own CA

- We can be our own certificate authority (CA) by creating a self-signed root CA certificate, and then installing it as a trusted certificate in the local browser.

### 5.1 Create a Self-Signed Root CA

- Let's create a private key (rootCA.key) and a self-signed root CA certificate (rootCA.crt) from the command line:

```bash
openssl req -x509 -sha256 -days 1825 -newkey rsa:2048 -keyout rootCA.key -out rootCA.crt
```

### 5.2 Sign Our CSR With Root CA

- First, we'll create a configuration text-file (domain.ext) with the following content:

```ext
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
subjectAltName = @alt_names
[alt_names]
DNS.1 = domain
```

- The “DNS.1” field should be the domain of our website.
- Then we can sign our CSR (domain.csr) with the root CA certificate and its private key:

```bash
openssl x509 -req -CA rootCA.crt -CAkey rootCA.key -in domain.csr -out domain.crt -days 365 -CAcreateserial -extfile domain.ext
```

## 6. View Certificates

- We can use the openssl command to view the contents of our certificate in plain text:

```shell
openssl x509 -text -noout -in domain.crt
```

## 7. Convert Certificate Formats

- Our certificate (domain.crt) is an X.509 certificate that's ASCII PEM-encoded. We can use OpenSSL to convert it to other formats for multi-purpose use.

### 7.1 Convert PEM to DER

- The DER format is usually used with Java. Let's convert our PEM-encoded certificate to a DER-encoded certificate:

```shell
openssl x509 -in domain.crt -outform der -out domain.der
```

### 7.2 Convert PEM to PKCS12

- PKCS12 files, also known as PFX files, are usually used for importing and exporting certificate chains in Microsoft IIS.

- We'll use the following command to take our private key and certificate, and then combine them into a PKCS12 file:

```shell
openssl pkcs12 -inkey domain.key -in domain.crt -export -out domain.pfx
```

## 8. Conclusion

- In this article, we learned how to create a self-signed certificate with OpenSSL from scratch, view this certificate, and convert it to other formats. We hope these things help with your work.

### Additional hints

#### Extract SSL Cert from domain using OpenSSL

```bash
export DOMAIN="gitlab.server.home"
openssl s_client -showcerts -connect ${DOMAIN}:443 -servername ${DOMAIN} < /dev/null 2>/dev/null | openssl x509 -outform PEM > /etc/gitlab-runner/certs/${DOMAIN}.crt
```
