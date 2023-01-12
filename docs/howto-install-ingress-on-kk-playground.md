# How-To: Install Kubernetes Ingress on KodeKloud Playgrounds

There have been a few questions about this in the community channels, so in this document I'll show how to set it up on the playgrounds.

Successfully deploying ingress takes quite a few manifests, and also the requirements change along with the version of Kubernetes, therefore the easiest way to do it is by using the [Helm](https://helm.sh/) chart for it [provided by the Kubernetes team](https://kubernetes.github.io/ingress-nginx/) which will keep pace with the current version of Kubernetes.

Don't worry if you don't know what Helm is or how to use it, simply follow the steps in this guide. Helm is covered in the CKAD course, though the usage here is slightly more advanced than is required for CKAD.

There are three steps to installing the chart and getting Ingress deployed

1. Download and install Helm

    ```bash
    wget https://get.helm.sh/helm-v3.10.3-linux-amd64.tar.gz
    tar -zxf helm-v3.10.3-linux-amd64.tar.gz
    mv linux-amd64/helm /usr/local/bin
    ```

2. Create a namespace in which to install Ingress, and set our context to it

    ```bash
    kubectl create namespace ingress-nginx
    kubectl config set-context --current --namespace ingress-nginx
    ```

3. Install the helm chart to deploy Ingress

    ```
    helm install ingress-nginx \
        --set controller.service.type=NodePort \
        --set controller.service.nodePorts.http=30080 \
        --set controller.service.nodePorts.https=30443 \
        --repo https://kubernetes.github.io/ingress-nginx \
        ingress-nginx
    ```

    Points to note here

    * The helm installation is called `ingress-nginx`
    * The three `--set` arguments are overriding settings in the `values.yaml` file to ensure we install the ingress controller's service as a `NodePort` service and to set the nodeports. The default is to install a `LoadBalancer` service, which can't be deployed in the playgrounds.
    * `--repo` tells Helm which repository to use instead of the default. This saves us having to use a separate Helm command to permanently add a local reference to the remote repository.
    * The final argument `ingress-nginx` is the name of the chart to install.


Following these steps, the ingress controller will be installed and listening on NodePort 30080. You should now be able to install an application that uses ingress, such as the wear/watch example in the CKAD course.

## Important

When declaring your ingress resource, be sure to set the `ingressClassName` for it:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
    nginx.ingress.kubernetes.io/ssl-redirect: "false"
  name: ingress-wear-watch
  namespace: app-space
spec:
  ingressClassName: nginx   # <- This is required to make it work
  # rest of spec here
```

## Viewing the ingress

To view your ingress once you've deployed an application, you need to select `View Port`, and enter the port number `30080` in the dialog that follows. You will initially get a 404 page, however you must append to the URL in the browser, e.g. `/wear` or `/watch` if you deployed the wear/watch application from CKAD.

![view-port](../img/view-port.jpg)

## Viewing the manifest

If you're interested in seeing all the YAML that creates the ingress controller, you can run the following command

```bash
helm template \
    --set controller.service.type=NodePort \
    --set controller.service.nodePorts.http=30080 \
    --set controller.service.nodePorts.https=30443 \
    --repo https://kubernetes.github.io/ingress-nginx \
    ingress-nginx |
    less
```

Press `ESC` to get out of the file viewer.
