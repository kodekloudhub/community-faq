# Certificate Signing Requests

We get a lot of questions about this one, specifically related to CKA mock exam 2, question 6

> How is it that the user we must create rolebindings for is "john" when we created a CertificateSigningRequest for "john-developer"?

In the question, you are given a CSR `john.csr` which is the X509 certificate signing request for the new user. This CSR contains the actual name of the user as the CN (common name) of the request.

Let's see this by decoding the CSR

```
openssl req -in john.csr -text -noout
```

The first few lines of output are

```
Certificate Request:
    Data:
        Version: 1 (0x0)
        Subject: CN = john
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                Public-Key: (2048 bit)
```
...and here you see the user name `john`. _This_ will be the user name within the cluster for associating rolebindings to.

Now, to pass this file to Kubernetes, we must create a `CertificateSigningRequest` resource, and embed the content of the `.csr` file into this resource as a base64 string.

1. Get the base64 content of the CSR file

    ```bash
    cat john.csr | base64
    ```

    Copy the output of the above command

1. Create a `CertificateSigningRequest` manifest

    ```yaml
    apiVersion: certificates.k8s.io/v1
    kind: CertificateSigningRequest
    metadata:
      name: john-developer  # <- This can be anything you like. Doesn't have to be "john".
    spec:
      request:  # <- Paste the output you copied above here.
      signerName: kubernetes.io/kube-apiserver-client
      expirationSeconds: 86400  # one day
      usages:
      - client auth
    ```

When you create the certificate signing request to apply with kubectl, the name of this can be whatever you like, because the name of the actual user is encoded in the CSR (which is the base64 encoded string passed as request in the certificate signing request manifest). The name of the user in the CSR has no bearing on what you decide to name the `CertificateSigningRequest` resource.

## What about the private key associated with the CSR file?

When the `CertificateSigningRequest` has been applied and approved in Kubernetes, a certificate for the new user may be obtained. A cluster administrator gives the cluster's CA certificate and the newly generated user certificate to the user.

The user then puts these, along with the key into their `~/.kube/config` file. The user certificate and key goes in the `users` section, and the CA certificate in the `clusters` section.

Together, these three items are used to provide [mutual TLS](https://www.cloudflare.com/en-gb/learning/access-management/what-is-mutual-tls/) (mTLS) authentication with the API server.
