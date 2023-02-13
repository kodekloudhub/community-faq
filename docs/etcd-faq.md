# ETCD FAQ

**IMPORTANT** Following recent student comments about the exam backup/restore questions,  this FAQ is currently under review. Once we ascertain what is actually required,  we will update this page, and the labs accordingly.

`etcd` is a distributed key-value store, kind of similar to a NoSQL database. It is the database backend chosen by the Kubernetes project for the storage of cluster state. It is a separate open source project that is not maintained by the Kubernetes developers, but no doubt they have some input on its development.

* [What is ETCDCTL_API=3 all about?](#what-is-etcdctlapi3-all-about)
* [When do I use --endpoints?](#when-do-i-use---endpoints)
* [What are all the certificates used for?](#what-are-all-the-certificates-used-for)
* [Should I stop API server and/or etcd during backup or restore?](#should-i-stop-api-server-andor-etcd-during-backup-or-restore)
* [How do I make a backup?](#how-do-i-make-a-backup)
* [How do I restore a backup?](#how-do-i-restore-a-backup)
    * [kubeadm clusters with etcd running as a pod](#kubeadm-clusters-with-etcd-running-as-a-pod)
      * [Troubleshooting after the restore](#troubleshooting-after-the-restore)
* [Clusters with external etcd](#clusters-with-external-etcd)
    * [Single etcd process](#single-etcd-process)
    * [Multiple etcd processes](#multiple-etcd-processes)
* [Advanced Usage](#advanced-usage)
    * [How do I read data directly from etcd?](#how-do-i-read-data-directly-from-etcd)
    * [How do I encrypt secrets at rest?](#how-do-i-encrypt-secrets-at-rest)

**NOTE**: In the exam, you are advised to skip this question and come back to it at the end, as it is probably the hardest one and you don't want to waste time if there are easier questions further on!!

## What is ETCDCTL_API=3 all about?

`etcdctl` supports two versions of the server's API. When making server calls, it defaults to version 2 of the API, and in version 2 some operations are either undefined, or have different arguments. Setting this environment variable tells `etcdctl` to use the V3 API, which is required for the snapshot functionality.

You may set the environment variable with each call...

```bash
ETCDCTL_API=3 etcdctl snapshot save ...
ETCDCTL_API=3 etcdctl snapshot restore ...
```

...or for the entire terminal session...

```bash
export ETCDCTL_API=3
etcdctl snapshot save ...
etcdctl snapshot restore ...
```

## When do I use --endpoints?

The `--endpoints` argument on `etcdctl` is used to tell it where to find the `etcd` server. If you are running the command on the same host where `etcd` service is running *and* there is only one instance of `etcd`, then you do not need to provide this argument, as it has a default value of `https://127.0.0.1:2379`.<br>This is the case in most labs, as your prompt will nearly always be on the controlplane node.

If you run `etcdctl` from a different workstation from where `etcd` is running, as may be the case in a production environment, *or* you need to use a non-standard port, then you need to provide this argument to say where the `etcd` server is. If you need to determine `host-ip` and/or `port` they can be found by looking at the etcd manifest (or systemd unit file when etcd is external) and finding this on the `--listen-client-urls` argument.

* Same host, different port: `--endpoints https://127.0.0.1:port`
* Remote host: `--endpoints https://host-ip:port`

## What are all the certificates used for?

When we take a backup, we have to pass three arguments related to certificates. This is because we must authenticate with the `etcd` server before it will divulge its sensitive data. The authentication scheme is called Mutual TLS (mTLS).

This is an extension of what happens when you browse to an HTTPS web site. For web sites, that is one-way TLS where the web server must prove its identity to the browser before an encrypted channel is established. In mTLS, both ends must prove their identity to each other.

Note that for *restore* on single `etcd` node clusters such as those found in the exam, it is not necessary to use the certificate arguments, since all the restore is doing is creating a directory. It does not need to communicate with the `etcd` server - which may even not be running if the exam deliberately sets it up with a corrupt database. You would only use certs and some additional arguments when restoring a broken node into what is left of a multi-node `etcd`, which is beyond the scope of CKA.

### --cacert

* This provides the path to the Certificate Authority (CA) certificate. The CA certificate is used to verify the authenticity of the TLS certificate sent to `etcdctl` by the `etcd` server. The server's certificate must be found to be *signed by* the CA certificate. When building a cluster, creating the CA is one of the tasks you need to do. `kubeadm` does it automatically, but to see how it is done manually (outside the scope of CKA exam), see [kubernetes the hard way](https://github.com/mmumshad/kubernetes-the-hard-way).

### --cert

* This is the path to the TLS certificate that `etcdctl` sends to the `etcd` server. The `etcd` server will verify that this certificate is also signed by the same CA certificate. Certificates of this type contain a *public key* which can be used to encrypt data. The public key is used by the server to encrypt data being sent back to `etcdctl` during the authentication steps.

### --key

* This is the path to the private key that is used to decrypt data sent to `etcdctl` by the `etcd` server during the authentication steps.


For ease, you will find that normally both `etcdctl` and `etcd` share all three certificates, and these are the ones usually found in `/etc/kubernetes/pki/etcd`, however it is possible to issue `etcdtl` with its own certificate and key which is considered more secure, but that certificate must have been signed by the shared CA certificate.

CA certificates are public knowledge. For HTTPS to work, your computer has copies of many well-known CA certificates, such as Comodo, DigiCert, GlobalSign etc. On Windows, these are located in the Trusted Root Certification Authorities section of the Certificate Manager application. When a web server passes its TLS certificate to the browser, it is these CA certificates it looks up to verify the identity of the web server.

For a more detailed explanation of how mTLS works, see [this page](https://www.cloudflare.com/en-gb/learning/access-management/what-is-mutual-tls/).

## Should I stop API server and/or etcd during backup or restore?

> No

Consider a production environment. In such environments, you would be making regular automated backups of etcd. If you stopped either of these processes, then the cluster could go offline, and you would be faced with a production major incident!

etcd is designed to ensure consistency in its backups even while in use, just as you would expect from any regular SQL database.

## How do I make a backup?

In order to take a backup, there are several required arguments, as we need to authenticate with the server to pull any data from it. These are

* `--cacert` - Path the the `etcd` CA certificate
* `--cert` - Path to the `etcd` server certificate
* `--key` - Path to the `etcd` server private key
* `--endpoints` - Only required in certain circumstances. See [this FAQ question](#when-do-i-use---endpoints).

On `kubeadm` clusters such as the labs, killer.sh or the exam, these files should be found in `/etc/kubernetes/pki/etcd` on the control plane node, which is where you should run `etcdctl` unless instructed otherwise. A question may also tell you which certs to use, in which case adjust the following accordingly.

Sample backup command

```bash
ETCDCTL_API=3 etcdctl snapshot save \
    --cacert /etc/kubernetes/pki/etcd/ca.crt \
    --cert /etc/kubernetes/pki/etcd/server.crt \
    --key /etc/kubernetes/pki/etcd/server.key \
    /opt/snapshot-pre-boot.db
```

## How do I restore a backup?

Normally you will restore this to another directory, and then point the `etcd` service at the new location. For restores, the certificate and endpoints arguments are not required, as all we are doing is creating files in directories and not talking to the `etcd` API, so the only argument required is `--data-dir` to tell `etcdctl` where to put the restored files.

What needs to be done following the restore to get `etcd` to use it depends on how the cluster is deployed.

Sample restore command

```bash
ETCDCTL_API=3 etcdctl snapshot restore \
    --data-dir /var/lib/etcd-from-backup \
    /opt/snapshot-pre-boot.db
```

### kubeadm clusters with etcd running as a pod

This is known as "stacked etcd"

It is a change to a single line in the manifest.

Determine that the cluster is configured this way by executing the following and determining that `etcd` is in the results

```
kubectl get pods -n kube-system
```

Now do the following on the control node.

1. Edit the manifest file for `etcd` on the controlplane node. This is found in <br>`/etc/kubernetes/manifests/etcd.yaml`.
1. Scroll down to the `volumes` section and find the volume that describes the data directory (see below).
1. Edit the `hostPath.path` of the volume with name `etcd-data` from `/var/lib/etcd` to `/var/lib/etcd-from-backup` (or whichever directory you used for the restore command). Note that you *do not* change the `--data-dir` command line argument to `etcd` in the container's command specification.
1. Wait about a minute for everything to reload.

This is the section in `etcd.yaml` that you need to find...

```yaml
  volumes:
  - hostPath:
      path: /etc/kubernetes/pki/etcd
      type: DirectoryOrCreate
    name: etcd-certs
  - hostPath:
      path: /var/lib/etcd    # <- change this
      type: DirectoryOrCreate
    name: etcd-data
```

Why does this work? You need to remember how mounting volumes in containers works.

* `volumes.hostPath.path` which you edited above specifies the directory on the node (host) where the data is stored. This is the actual location of where the backup was restored to.
* `containers.volumeMounts.mountPath` specifies the directory *inside* the container where the host data is mounted. We haven't changed that. From the `etcd` container's point of view, the directory is still `/var/lib/etcd`.

And note...

```yaml
  containers:
  - command:
    - etcd
    - --advertise-client-urls=https://10.40.10.9:2379
    - --cert-file=/etc/kubernetes/pki/etcd/server.crt
    - --client-cert-auth=true
    - --data-dir=/var/lib/etcd                  # <- DO NOT CHANGE THIS!
    - --initial-advertise-peer-urls=https://10.40.10.9:2380
    - --initial-cluster=controlplane=https://10.40.10.9:2380
```

#### Troubleshooting after the restore

It can take up to 60 seconds for service to resume after you have edited the `etcd` manifest. You may observe the progress of the pod restarts by running the following command. As mentioned above, give it up to 60 seconds to become stable.

```bash
watch crictl ps
```

This will show you the running _containers_, refreshing the list every two seconds. You are waiting for the following to be stable:

```
Every 2.0s: crictl ps                                                                                                                                    controlplane: Thu Jan 26 01:50:48 2023

CONTAINER           IMAGE               CREATED             STATE               NAME                      ATTEMPT             POD ID              POD
c6e61480ac614       a31e1d84401e6       9 minutes ago       Running             kube-apiserver            6                   2623ac5d1b43b       kube-apiserver-controlplane
629d81d592938       fce326961ae2d       10 minutes ago      Running             etcd                      0                   87710b3c9a99a       etcd-controlplane
3715d4173cc9f       5d7c5dfd3ba18       15 minutes ago      Running             kube-controller-manager   1                   bd8758b9de774       kube-controller-manager-controlplane
b182a4a2ba76d       dafd8ad70b156       15 minutes ago      Running             kube-scheduler            1                   3359954829552       kube-scheduler-controlplane
e431a0ba0c04d       5185b96f0becf       23 minutes ago      Running             coredns                   0                   8d65a558ea93d       coredns-787d4945fb-2jn9w
b8e8d94ea1074       5185b96f0becf       23 minutes ago      Running             coredns                   0                   7dc120679094d       coredns-787d4945fb-xj4ll
fc30b4a42a287       8b675dda11bb1       23 minutes ago      Running             kube-proxy                0                   d73933f8fac41       kube-proxy-b9cv2
```

All the containers must be stable, i.e. not flipping on and off the list and `ATTEMPT` value should stop increasing. There may be other containers, but the ones in this list are the important ones. To get out of this display, press `CTRL-C`. Now you should be able to run `kubectl` commands again.

If the `etcd` pod does not come back up in a reasonable time, you can [troubleshoot the same way as for apiserver](./diagnose-crashed-apiserver.md).

## Clusters with external etcd

This covers both `kubeadm` clusters where `etcd` is *not* running as a pod, and fully manual installations like [kubernetes the hard way](https://github.com/mmumshad/kubernetes-the-hard-way).

Some people have suggested that this is how some of the `etcd` questions the exam question bank are set up, as in you have to do it all from some node other than the control node for the target cluster. It requires a bit more work, but it doesn't mean that you will definitely get a question that is this way and not stacked-mode as above!

If you do find that your backup/restore question is an External etcd, then definitely flag the question and leave it till last!

On the node where you are instructed to do the task, first become root, if you are not already root.

```bash
sudo -i
```

Next, determine how many `etcd` processes there are

```
ps -aux | grep etcd
```

The output looks like this

> etcd&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;804&nbsp;&nbsp;&nbsp;&nbsp;0.0  0.0 11217856 46296 ?      Ssl  10:10   0:08 /usr/local/bin/etcd --name etcd-server --data-dir=/var/lib/etcd-data --cert-file=/etc/etcd/pki/etcd.pem --key-file=/etc/etcd/pki/etcd-key.pem --peer-cert-file=/etc/etcd/pki/etcd.pem --peer-key-file=/etc/etcd/pki/etcd-key.pem --trusted-ca-file=/etc/etcd/pki/ca.pem --peer-trusted-ca-file=/etc/etcd/pki/ca.pem --peer-client-cert-auth --client-cert-auth --initial-advertise-peer-urls <span>https://</span>10.21.18.18:2380 --listen-peer-urls <span>https://</span>10.21.18.18:2380 --advertise-client-urls <span>https://</span>10.21.18.18:2379 `--listen-client-urls https://10.21.18.18:2379,https://127.0.0.1:2379` --initial-cluster-token etcd-cluster-1 --initial-cluster etcd-server=https://10.21.18.18:2380 --initial-cluster-state new<br>
root&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1106&nbsp;&nbsp;&nbsp;&nbsp;0.0  0.0  13448  1064 pts/0    S+   10:17   0:00 grep etcd

In the above, there is one instance of `etcd` running. If there were more, then you would see additional big blocks of `etcd` arguments. It should be highly unusual to be faced with more than one `etcd` running on the same host in the exam. If you have seen more than one `etcd`, please post in the [slack channel](https://kodekloud.slack.com/archives/CHMV3P9NV). Don't include full details of the question, as that would violate NDA. Only state that you have seen multiple external etcd processes.

In the exam, use the `mousepad` application to take notes.

### Single etcd process

1. Note down the port number from `--listen-client-urls`. It will be unusual (not impossible) if it is something other than `2379`
1. Determine the name of the `etcd` service unit. Note that the service unit files end with `.service`. When referring to a service uint with `sysemctl` commands, it is not necessary to type `.service` - it is assumed, therefore less typing!

    ```bash
    systemctl list-unit-files | grep etcd
    ```

    > Output will be like

      ```
      etcd.service                               enabled         enabled
      ```
1. If the location of the service unit file has not been given in the question, then you must locate it. You will need to edit it later if you have to do a restore.

    ```bash
    systemctl cat etcd
    ```

    > Output (some lines truncated. Important lines are shown)

      ```bash
      # /etc/systemd/system/etcd.service
      [Unit]
      Description=etcd
      Documentation=https://github.com/coreos

      [Service]
      ExecStart=/usr/local/bin/etcd \
      --- truncated---
        --listen-client-urls https://192.168.56.11:2379,https://127.0.0.1:2379
      --- truncated---
        --data-dir /var/lib/etcd
      ```

      * Note the first line which is a comment. This is the full path to the file. Note it down, you will need to edit this file later if doing a restore.
      * Note also the values for `--listen-client-urls`

1. If you have been instructed to take a backup, then you should have been given the path to the certificates to use with `etcdctl`. If you have only been given a *directory* name, rather than all three certificates, do an `ls -l` of this directory to determine the certificate/key names.<br>For instance, if the directory given is `/etc/etcd/pki` and you find this contains `ca.crt`, `server.crt` and `server.key` then the command would be

    ```bash
    ETCDCTL_API=3 etcdctl snapshot save \
      --cacert /etc/etcd/pki/ca.crt \
      --cert /etc/etcd/pki/server.crt \
      --key /etc/etcd/pki/server.key \
      /path/to/snapshot.db
    ```

    Note that if the port number on `--listen-client-urls` is not 2379, then you also require `--endpoints`

1. If you have been instructed to do a restore then

    1. Determine the ownership of the original data directory as found in the unit file above at `--data-dir`

        ```bash
        ls -ld /var/lib/etcd
        ```

        > Output - here we see it is owned by `etcd:etcd`

            drwx------ 3 etcd etcd 4096 Nov 28 01:18 /var/lib/etcd

    1. Do the restore to whichever directory instructed by the question. For instance, if it is `/var/lib/etcd-from-backup` then

        ```bash
        ETCDCTL_API=3 etcdctl snapshot restore \
          --data-dir /var/lib/etcd-from-backup \
          /path/to/snapshot.db
        ```

    1. If the original data directory was not owned by root, set the ownership of the newly created directory to the correct user:group

        ```bash
        chown -R etcd:etcd /var/lib/etcd-from-backup
        ```

    1. Now edit the system uint file with `vi` using the path you noted above and set `--data-dir` to where you did the restore, e.g. `/var/lib/etcd-from-backup`

        ```bash
        vi /etc/systemd/system/etcd.service
        ```

    1. Restart the `etcd` service

        ```bash
        systemctl daemon-reload
        systemctl restart etcd
        ```

### Multiple etcd processes

It is highly unlikely you will find this configuration, but if you do, please report it in the [slack channel](https://kodekloud.slack.com/archives/CHMV3P9NV).

If there's more than one, you need to identify the correct one! In the output of the above `ps -aux | grep etcd` command, you should be able to see the `--listen-client-urls` argument. Note down the port numbers from this URL for each `etcd` process.

1. Go onto the control node for the target cluster and run

    * If it is a kubeadm cluster (api server is running as a pod). It should be like this in the exam.

        ```
        grep etcd-servers /etc/kubernetes/manifests/kube-apiserver.yaml
        ```

    * If it is not kubeadm, and api server is an operating system service

      ```
      sudo ps -aux | grep apiserver
      ```

      Find `--etcd-servers` in the argument list and note the port number. You need to match that with one of the port numbers you've noted down above. That will get you the correct `etcd` process.

    Log out of the control node and return to the node running `etcd`. When you get there, remember to do `sudo -i` again if needed.

1. Next, find the unit file for the correct `etcd` service. The following will give you the file *names*.

    ```bash
    systemctl list-unit-files | grep etcd
    ```

    > Output will be something like

        ```
        etcd-1.service                               enabled         enabled
        etcd-2.service                               enabled         enabled
        ```

1. To locate these files, run the following on each filename returned by the command above

    ```bash
    systemctl cat etcd-1
    systemctl cat etcd-2
    ```

    Refer to above sections for what the output looks like. Find the correct one by examining each identified unit file and choose the one that has the matching port number for the `--listen-client-urls` argument. You will need to edit this later if doing a restore.

1. If you have been instructed to take a backup, then identify the certificates as per instructions for single etcd above and form the backup command in the same way, but additionally specify `--endpoint CLIENT_URL` where `CLIENT_URL` is the URL from the<br/>`--listen-client-urls` in the identified unit file. Choose the `https://127.0.0.1:...` URL if present.

1. If you have been instructed to do a restore

    1. Perform the same steps as for single etcd to form the restore command, and to set directory ownership.
    1. Edit the correct service unit file identified above and set the new `--data-dir`
    1. Restart the identified service with `systemctl daemon-reload` and `systemctl restart`

Please also try the following lab for practice of external etcd

> https://kodekloud.com/topic/practice-test-backup-and-restore-methods-2-2/

# Advanced Usage

This section contains topics that may come up in CKS exam. You do not need to know this for CKA.

## How do I read data directly from etcd?

You may get a question that asks you to get data directly from the etcd database, for instance the content of a secret.

ETCD in Kubernetes stores data under `/registry/{type}/{namespace}/{name}`.

Thus, if you were looking for a `secret` called `database-access` in namespace `team-green`, the key path would be

```
/registry/secrets/team-green/database-access
```

To read this data, you would run the following `get` command

```
ETCDCTL_API=3 etcdctl \
  --cacert /etc/kubernetes/pki/etcd/ca.crt \
  --cert /etc/kubernetes/pki/apiserver-etcd-client.crt \
  --key /etc/kubernetes/pki/apiserver-etcd-client.key \
  get /registry/secrets/team-green/database-access
```

The same rules [discussed above](#when-do-i-use---endpoints) apply to the use of `--endpoints`

## How do I encrypt secrets at rest?

Secrets are more or less human readable when stored in etcd. To store them in an encrypted form you need to create an encryption configuration file, then update the API server manifest to make use of it. The steps to do this are detailed [here](https://kubernetes.io/docs/tasks/administer-cluster/encrypt-data/#encrypting-your-data).

Once the configuration is properly applied, you can encrypt existing secrets by replacing them.

All secrets in the cluster

```
kubectl get secrets --all-namespaces -o json | kubectl replace -f -
```

A single namespace

```
kubectl get secrets -n some_namespace -o json | kubectl replace -f -
```

A single secret

```
kubectl get secrets my_secret -o json | kubectl replace -f -
```

In our [kubernetes the hard way](https://github.com/mmumshad/kubernetes-the-hard-way) labs, we enable secret encryption at rest by default.


[Return to main FAQ](../README.md)
