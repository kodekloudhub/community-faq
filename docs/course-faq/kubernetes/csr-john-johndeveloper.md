# CSRs - What is it with john and john-developer?

This is regarding CKA Mock Exam 2, question 6. This question is as follows

> Create a new user called `john`. Grant him access to the cluster.<br/>John should have permissions to `create, list, get, update and delete pods` in the `development` namespace. The private key exists in the location `/root/CKA/john.key` and csr at `root/CKA/john.csr`.

In this FAQ, we will concentrate on the first validation condition

* CSR: `john-developer`. Status: Approved

Contents

* [The Actors](#the-actors)
* [The Confusion](#the-confusion)
* [The Explanation](#the-explanation)
* [Creating a key and csr](#creating-a-key-and-csr)
* [Creating a CertificateSigningRequest](#creating-a-certificatesigningrequest)

## The Actors

There are three entities involved

1. The new user's private key: `/root/CKA/john.key`.
1. His x509 CSR: `/root/CKA/john.csr`.
1. The Kubernetes `CertificateSigningRequest` (confusingly also referred to as CSR) we will create to present the CSR from #2 to the cluster.

## The Confusion

Why does a `CertificateSigningRequest` created as `john-developer` represent a user called `john`?

## The Explanation

When a user wants access to a cluster, that user must do the following

1. Create a private key (e.g. `john.key`).
1. With this key, create an x509 certificate signing request (e.g. `john.csr`).
1. Give the `.csr` file to the cluster administrator.

The cluster administrator then does the following

1. Create a `CertificateSigningRequest` in the cluster using the `.csr` file provided.
1. Approve the `CertificateSigningRequest`.
1. Create roles and role bindings appropriate for the new user's level of access.
1. Extract the x509 certificate (as a `.crt`) file and return that and the cluster's CA certificate to the user, so that the user may add these to their KUBECONFIG along with the key which they already have.

Note that the certificate (`.crt`) and signing request (`.csr`) files are public knowledge and can safely be passed between user and administrator via email. They are no use without the private key (`.key`) file which the user must keep protected. It is still advisable to delete these emails once the user creation is complete and working.

Now, let's look at how the user's name is `john` and _not_ `john-developer`. When creating the x509 signing request, the user embeds the name they wish to be known by in the cluster _in that file_.

Let us examine the x509 CSR:

```bash
openssl req -in /root/CKA/john.csr -noout -text
```

The first few lines of output from the above command looks like this

```
Certificate Request:
    Data:
        Version: 1 (0x0)
        Subject: CN = john
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                RSA Public-Key: (2048 bit)
```

Note this: `Subject: CN = john`. The subject field is known as "distinguished name" (DN) and can have several components. This DN has only the one component `CN` which represents "Common Name", which you can see is `john`. The CN in an x509 CSR is what the user's name will be in the cluster.

Now when the cluster admin comes to add the user from the CSR file, then the admin will create a `CertificateSigningRequest` using the base64 encoded data from the user's provided `.csr` file, like this

```yaml
 apiVersion: certificates.k8s.io/v1
 kind: CertificateSigningRequest
 metadata:
   name: john-developer
 spec:
   signerName: kubernetes.io/kube-apiserver-client
   request: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURSB-some-stuff-truncated-for-brevity==
   usages:
   - client auth
   groups:
   - system:authenticated
```

The important thing to know is that the `name` on this `CertificateSigningRequest` _has no bearing_ on the name of the user. It is only a name with which to refer to the `CertificateSigningRequest` resource to approve it and get back the certificate. If we instead did

```yaml
 apiVersion: certificates.k8s.io/v1
 kind: CertificateSigningRequest
 metadata:
   name: ipsum-lorem
 spec:
   signerName: kubernetes.io/kube-apiserver-client
   request: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURSB-some-stuff-truncated-for-brevity==
   usages:
   - client auth
   groups:
   - system:authenticated
```

...but leave all the other properties (and crucially the base64 data in `request`) unchanged, the result is still the same. The user's name is still `john`; it does not suddenly become `ipsum-lorem`!<br/>You must remember that the user's name is embedded in the `request` data, as coming from the `.csr` file.

**PRO TIP!**

When creating a CertificateSigningRequest from a CSR, save yourself the trouble of trying to paste the base64 content of the `.csr` file into the resource and possibly messing up the copy/paste. Instead turn the resource creation into a shell command.

1. Open vi on a new file, let's call it `create-csr.sh`
1. Copy the [template from the documentation](https://kubernetes.io/docs/reference/access-authn-authz/certificate-signing-requests/#create-certificatessigningrequest) and paste that into the editor.
1. Delete the base64 text that comes after `request:`
    1. Hit ESC to return vi to Normal mode.
    1. Move cursor to the start of the base64 text, then hit `SHIFT-D` to delete to end of line.
1. Hit `A` to re-enter insert mode at end of current line.
1. Now fill in `$(cat john.csr | base64 -w 0)`, then edit the name to be the correct one. It should now look like this:

    ```bash
    cat <<EOF | kubectl apply -f -
    apiVersion: certificates.k8s.io/v1
    kind: CertificateSigningRequest
    metadata:
      name: john-developer
    spec:
      request: $(cat john.csr | base64 -w 0)
      signerName: kubernetes.io/kube-apiserver-client
      expirationSeconds: 86400  # one day
      usages:
      - client auth
    groups:
    - system:authenticated
    EOF
    ```
1. Save and exit vi.
1. Apply the resource

    ```bash
    bash -c create-csr.sh
    ```
Anyone having knowledge of Linux and shell will recognize this as substitution in a HERE document, which is being piped into `kubectl apply`.

## Creating a key and csr

Now I'll explain how `john.key` and `john.csr` get created in the first place, and how you put your user name (and optionally a group) into the request.

1. Create the private key

    The key is RSA, 2048 bit encrpytion

    ```bash
    openssl genrsa -out john.key 2048
    ```

1.  Create the CSR, setting the requested user name

    ```bash
    openssl req -new -key john.key -subj "/CN=john" -out john.csr
    ```

    See that we are setting the `subject` field and within that the "Common Name" which will be `john`

Some people ask how to associate new users with a non-default group membership. To do this, you additionally set the "Organization" (O) field which is interpreted by Kubernetes as a group name:

```bash
openssl req -new -key john.key -subj "/CN=john/O=dev-group" -out john.csr
```

See also [What is a distinguished name](https://knowledge.digicert.com/generalinformation/INFO1745.html). Note that Kubernetes only cares about the CN and O fields for user certificate requests.

## Creating a CertificateSigningRequest

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
      expirationSeconds: 86400  # one day before the request is automatically revoked if you haven't approved it.
    usages:
    - digital signature
    - key encipherment
    - client auth
    groups:
    - system:authenticated
    ```

## See Also

This [video](https://www.youtube.com/watch?v=I-iVrIWfMl8) and this [blog post](https://articles.adityasamant.dev/blog/kubernetes/kubectl-auth-can-i/) created by one of our [Kubestronaut](https://www.cncf.io/training/kubestronaut/) qualified students.