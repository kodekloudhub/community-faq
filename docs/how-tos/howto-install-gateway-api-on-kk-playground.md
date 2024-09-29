# How-To: Configure Kubernetes API gateway

You can do this exercise either on the KodeKloud Kubernetes (latest version) Playground or on a cluster [you have built yourself](https://github.com/kodekloudhub/certified-kubernetes-administrator-course/tree/master/kubeadm-clusters).


## What is API Gateway?

API Gateway is an extension to and enhancement of regular ingress. In order to use API gateway, we must first install an API Gateway compatible ingress controller (note that this step should not be something you would have to do in CKA exam). Then we can utilise the new `gateway.networking.k8s.io/v1` APIs of Kubernetes to route and control traffic to services we've deployed in the cluster using more granular rules than was possible with ingress.

Gateway is not a "thing" in Kubernetes. Gateway API is only a set of Custom Resource Definitions (CRDs) that defines a standard to which implementation providers must conform to.

These APIs were developed by the Kubernetes Networking Special Interest Group (SIG) to bring together all the disparate CRDs for routing and gateways from all the different implementations to make it easier to swap one implementation for another without having to replace all the routing and gateway resources in your cluster.

The actual implementations are third party, e.g. [Kong](https://docs.konghq.com/gateway/latest/), [Traefik](https://traefik.io/blog/getting-started-with-kubernetes-gateway-api-and-traefik/) and [Istio](https://istio.io/latest/docs/tasks/traffic-management/ingress/gateway-api/) to name but a few. Note that some of these providers have additional functionality which is not yet covered by the Gateway APIs. Work is ongoing between the SIG and the providers to extend the APIs to include these in a standardised way.

Now, let's proceed to configuring a gateway. At this point it is not clear how much of the following needs to be known for the new CKA exam.

## Install API Gateway CRDs and a compatible ingress controller

This will almost certainly *not* be required for the exam, since ingress controller installation was not required, plus as mentioned above, there are several gateway controller implementations and you cannot be expected to learn all the configurations, nor are their websites allowed exam resources.

We will use the Traefik (pronounced "traffic") ingress controller and use Helm to install it so as not to concern ourselves with the detail

1. Install the Gateway API Custom Resource Definitions

    These are *not included* in a default Kubernetes installation, so if not present we must install them.

    1. Check if already present

        ```
        kubectl get gatewayclass
        ```

        If you *do not* get an error, proceed to installing Helm, else...

    1. Install the CRDs

        ```
        kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.1.0/standard-install.yaml
        ```

1. Install Helm if it is not already present

    ```
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
    chmod 700 get_helm.sh
    ./get_helm.sh
    ```

1. Add Traefik repo to Helm

    ```
    helm repo add traefik https://traefik.github.io/charts
    helm repo update
    ```

1. Install Traefik and configure it to use NodePorts since we cannot provision a load balancer

    1. Create a namespace to install to

        ```
        kubectl create namespace traefik
        ```

    1. Create a custom values file to configure traefik the way we want it

        Save the following as `values.yaml`

        ```yaml
        providers:
          kubernetesIngress:
            enabled: false          # Disable classic ingress functionality
          kubernetesGateway:
            enabled: true           # Enable API Gateway functionality
        service:
          type: NodePort            # Create the service as NodePort (default is LoadBalancer)
        ports:
          web:
            port: 8000              # Port that the controller communicates with Gateway resources on
        ```

    1. Install the controller with our custom settings

        ```
        helm install \
            --version 31.1.1 \
            --namespace traefik \
            --values values.yaml \
            traefik traefik/traefik
        ```

    The installation will also install a correctly configured `GatewayClass` resource to refer to the Traefik controller and a `Gateway` resource for the controller's internal use. You can inspect these with

    ```
    kubectl get gatewayclass traefik -o yaml
    kubectl get gateway -n traefik traefik -o yaml
    ```

## Configure a gateway for our own routes

This *may* be required for the exam.

Here we create a `Gateway` resource that connects our ClusterIP services with the API gateway. It will serve hosts in the `example.com` domain externally, and also allow connections from `HTTPRoute`s in any namespace.

1. Create a `Gateway` resource that will be used to route our traffic.

    This manifest must be applied in the same namespace in which we installed the controller. It links the Traefik ingress to the `GatewayClass` we just defined, and sets up a listener on port 80

    ```yaml
    apiVersion: gateway.networking.k8s.io/v1
    kind: Gateway
    metadata:
      name: my-example-com-gateway
      namespace: traefik            # This is where Traefik is installed
    spec:
      gatewayClassName: traefik     # Use the gateway class created by traefik deployment (like ingressClass for traditional ingress)
      listeners:
      - name: http                  # Connect to controller's listener
        protocol: HTTP
        port: 8000                  # Port number we configured in values.yaml above
        hostname: "*.example.com"   # Domain we will serve (any hostname in this domain)
        allowedRoutes:
          namespaces:
            from: All               # Allow HTTPRoute from any namespace
    ```

## Create a deployment and expose it on the gateway

This definitely *will* be in the exam. This is the API Gateway equivalent of defining an `Ingress` for a service.

1. Create a deployment and expose it

    ```
    kubectl create deployment nginx --image nginx
    kubectl expose deployment nginx --name nginx-service --port 80 --target-port 80
    ```

    Now we have a `Service` called `nginx-service` which we will expose via the gateway

1. Create an `HTTPRoute` to connect the service to the gateway

    ```yaml
    apiVersion: gateway.networking.k8s.io/v1
    kind: HTTPRoute
    metadata:
      name: nginx-route
      namespace: default
    spec:
      parentRefs:
      - name: my-example-com-gateway    # Name of the Gateway created above
        namespace: traefik              # Namespace where the above Gateway is deployed
        sectionName: http               # Specific lstener in the Gateway resource
        port: 8000
      hostnames:
      - nginx.example.com               # Hostname for this service
      rules:                            # The rules are similar to Ingress
      - matches:
        - path:
            type: PathPrefix
            value: /
        backendRefs:                    # Can have more than one service to implement blue/green and canary.
        - name: nginx-service           # Service we created
          port: 80                      # and the port it listens on
    ```

1. Test it

    Do a curl to the NodePort of the controller. We must provide the host header here, since we do not have a DNS entry for `nginx.example.com`, and like ingress, the host header is used to determine which service should receive the request.

    ```
    curl -H "Host: nginx.example.com"  http://localhost:30080
    ```

    You should see the HTML for the nginx welcome page.

## Using a browser

Note that this only works if you [built your own cluster](https://github.com/kodekloudhub/certified-kubernetes-administrator-course/tree/master/kubeadm-clusters) using VMs on your laptop.

1. Determine the address of any of the cluster nodes. This was output at the end of `vagrant up`. Alternatively `vagrant ssh` to one of the cluster nodes and run

    ```bash
    echo $PRIMARY_IP
    ```

1. Edit your hosts file

    * Windows: `C:\Windows\System32\drivers\etc\hosts` - open in notepad "As Administrator"
    * Mac: `/etc/hosts` - use `sudo vi`

1.  Add an entry for `nginx.example.com`

    Add this line replacing `<ip-address>` with the IP you determined in step 1, then save the file

    ```
    <ip-address> nginx.example.com
    ```

1. Browse the API gateway node port:

    ```
    http://nginx.example.com:30080
    ```

## Traffic Switching

Let's now create two services representing two versions of an application and demonstrate traffic switching. This technique allows us to manage blue/green and canary deployments.

1. Create and expose two deployments

    <details>
    <summary>Expand YAML</summary>

    This manifest will create both deployments and both services

    ```yaml
    # ConfigMap that contains a really simple server written in bash.
    # It returns whatever is in environment variable MESSAGE when it receives a request.
    apiVersion: v1
    kind: ConfigMap
    metadata:
      name: echo-configmap
    data:
      entrypoint.sh: |
        #!/bin/sh
        echo $MESSAGE > index.htm  #<- Message
        port=1111                       #<- Server Port
        # Run server...
        while true
        do
            { echo -ne "HTTP/1.0 200 OK\r\nContent-Length: $(wc -c <index.htm)\r\n\r\n"; cat index.htm; } | nc -l -p $port
        done

    ---

    # Version 1 deployment
    # Runs script in the ConfigMap
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      creationTimestamp: null
      labels:
        app: echo-v1
      name: echo-v1
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: echo-v1
      template:
        metadata:
          creationTimestamp: null
          labels:
            app: echo-v1
        spec:
          containers:
          - image: alpine:3.19
            name: server
            env:
            - name: MESSAGE
              value: VERSION ONE
            command:
            - /opt/server/entrypoint.sh
            volumeMounts:
            - name: script
              mountPath: /opt/server
          volumes:
          - name: script
            configMap:
              name: echo-configmap
              defaultMode: 0755

    ---

    apiVersion: v1
    kind: Service
    metadata:
      labels:
        app: echo-v1
      name: echo-v1
      namespace: default
    spec:
      ports:
      - port: 80
        protocol: TCP
        targetPort: 1111
      selector:
        app: echo-v1
    ---

    # Version 2 deployment
    # Runs script in the ConfigMap
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      creationTimestamp: null
      labels:
        app: echo-v2
      name: echo-v2
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: echo-v2
      template:
        metadata:
          creationTimestamp: null
          labels:
            app: echo-v2
        spec:
          containers:
          - image: alpine:3.19
            name: server
            env:
            - name: MESSAGE
              value: VERSION TWO
            command:
            - /opt/server/entrypoint.sh
            volumeMounts:
            - name: script
              mountPath: /opt/server
          volumes:
          - name: script
            configMap:
              name: echo-configmap
              defaultMode: 0755

    ---

    apiVersion: v1
    kind: Service
    metadata:
      labels:
        app: echo-v2
      name: echo-v2
      namespace: default
    spec:
      ports:
      - port: 80
        protocol: TCP
        targetPort: 1111
      selector:
        app: echo-v2
    ```
    </details>

1. Test the deployments

    ```
    kubectl run test --image wbitt/network-multitool
    # wait a few seconds
    kubectl exec -t test -- curl -s http://echo-v1
    kubectl exec -t test -- curl -s http://echo-v2
    kubectl delete pod test
    ```

1. Now create an `HTTPRoute` which includes *both* services

    ```yaml
    apiVersion: gateway.networking.k8s.io/v1
    kind: HTTPRoute
    metadata:
      name: echo-route
      namespace: default
    spec:
      parentRefs:
      - name: my-example-com-gateway    # Name of the Gateway created above
        namespace: traefik              # Namespace where the above Gateway is deployed
        sectionName: http               # Specific listener in the Gateway resource
        port: 8000
      hostnames:
      - echo.example.com                # Hostname for this service
      rules:                            # The rules are similar to Ingress
      - matches:
        - path:
            type: PathPrefix
            value: /
        backendRefs:                    # Can have more than one service to implement blue/green and canary.
        - name: echo-v1                 # V1 of service we created
          port: 80                      # and the port it listens on
          weight: 1                     # Equally weighted (take 50% traffic)
        - name: echo-v2                 # V2 of service we created
          port: 80                      # and the port it listens on
          weight: 1                     # Equally weighted (take 50% traffic)
    ```

1. Test it

    From controlplane to gateway's node port (again we must use host header):

    ```
    curl -s -H "Host: echo.example.com" http://localhost:30080
    ```

    You should now see the response alternate between `VERSION ONE` and `VERSION 2`

    Try editing the `HTTPRoute` and setting the weight of one of the service to `2`. Now the traffic is a `2:1` ratio, so the version with a weighting of `2` should appear twice as frequently as the other.

    ```
    kubectl edit httproute echo-route
    ```

    What happens if you set one of them to zero?