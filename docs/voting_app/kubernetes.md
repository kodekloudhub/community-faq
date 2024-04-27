# Deploying the Demo Voting App on Kubernetes

**IMPORTANT**: Note that all the container images for the demo voting app are built for `linux_amd64` which means that they will _not_ run on a cluster built on Mac M1/M2.

First, ensure you have a fully functional cluster. Here we test on

* [Minikube](https://minikube.sigs.k8s.io/docs/start/)
* [3-Node cluster on Hyper-V VMs](#3-node-kubeadm-cluster-running-on-ubuntu-2204)

# Deploy the application

Note that to order that resources are created is significant. The worker app especially will CrashLoop if it is deployed before the services it depends on.

Note that applications depend on databases, therefore we _must_ deploy everything related to storing data first, that is, the `postgres` database and `redis`.

1. Clone the voting app repository

    ```bash
    git clone https://github.com/kodekloudhub/example-voting-app-kubernetes.git
    cd example-voting-app-kubernetes
    ```
1. Deploy the `postgres` deployment

    ```bash
    kubectl apply -f postgres-deploy.yaml
    ```

1. Deploy the `postgres` service

    ```bash
    kubectl apply -f postgres-service.yaml
    ```

1. Deploy the `redis` deployment

    ```bash
    kubectl apply -f redis-deploy.yaml
    ```

1. Deploy the `redis` service

    ```bash
    kubectl apply -f redis-service.yaml
    ```
1. Ensure `redis` and `postgres` pods are fully started

    ```bash
    kubectl get pods
    ```

1. Deploy the `worker-app` deployment

    ```bash
    kubectl apply -f worker-app-deploy.yaml
    ```

    Note that this image may take a long time to pull depending on your connection. The image is 1.71GB. Status will be `ContainerCreating` and if you describe the pod, you will see that it is pulling.

1. Deploy the `voting-app` deployment

    ```bash
    kubectl apply -f voting-app-deploy.yaml
    ```

1. Deploy the `voting-app` service

    ```bash
    kubectl apply -f voting-app-service.yaml
    ```
1. Deploy the `result-app` deployment

    ```bash
    kubectl apply -f result-app-deploy.yaml
    ```
    
1. Deploy the `result-app` service

    ```bash
    kubectl apply -f result-app-service.yaml
    ```

1. Now wait for all pods to be running

    ```bash
    kubectl get pods
    ```

## Accessing the application

Both the voting app and result app create nodeport services. On `kubeadm` clusters, simply connect to the exposed nodeport. On `minikube` you need to run the following commands to get the URLs to paste to the browser. If using Windows/Docker, you'll have to run each command in a separate terminal.

```bash
minikube service voting-service --url
minikube service result-service --url
```

# Installation Logs

## Windows - Minikube

* Windows 11
* [Minikube](https://minikube.sigs.k8s.io/docs/start/) 1.30.1
* [Docker Desktop](https://www.docker.com/products/docker-desktop/) 4.18.0

<details>
<summary>Expand for installation log</summary>

```
PS C:\Temp>  git clone https://github.com/kodekloudhub/example-voting-app-kubernetes.git
Cloning into 'example-voting-app-kubernetes'...
remote: Enumerating objects: 18, done.
remote: Counting objects: 100% (10/10), done.
remote: Compressing objects: 100% (9/9), done.
remote: Total 18 (delta 6), reused 1 (delta 1), pack-reused 8
Receiving objects: 100% (18/18), 4.05 KiB | 345.00 KiB/s, done.
Resolving deltas: 100% (6/6), done.
PS C:\Temp> cd .\example-voting-app-kubernetes\
PS C:\Temp\example-voting-app-kubernetes (main)> kubectl apply -f postgres-deploy.yaml
deployment.apps/postgres-deploy created
PS C:\Temp\example-voting-app-kubernetes (main)> kubectl apply -f postgres-service.yaml
service/db created
PS C:\Temp\example-voting-app-kubernetes (main)> kubectl apply -f redis-deploy.yaml
deployment.apps/redis-deploy created
PS C:\Temp\example-voting-app-kubernetes (main)> kubectl apply -f redis-service.yaml
service/redis created
PS C:\Temp\example-voting-app-kubernetes (main)> kubectl get pods
NAME                               READY   STATUS    RESTARTS   AGE
postgres-deploy-55db97fbd9-5vx5m   1/1     Running   0          105s
redis-deploy-598c448457-dxqhl      1/1     Running   0          88s
PS C:\Temp\example-voting-app-kubernetes (main)> kubectl apply -f worker-app-deploy.yaml
deployment.apps/worker-app-deploy created
PS C:\Temp\example-voting-app-kubernetes (main)> kubectl get pods
NAME                                 READY   STATUS              RESTARTS   AGE
postgres-deploy-55db97fbd9-5vx5m     1/1     Running             0          6m
redis-deploy-598c448457-dxqhl        1/1     Running             0          5m43s
worker-app-deploy-6dbf88866b-t8285   0/1     ContainerCreating   0          4m2s
PS C:\Temp\example-voting-app-kubernetes (main)> kubectl get pods
NAME                                 READY   STATUS    RESTARTS   AGE
postgres-deploy-55db97fbd9-5vx5m     1/1     Running   0          7m17s
redis-deploy-598c448457-dxqhl        1/1     Running   0          7m
worker-app-deploy-6dbf88866b-t8285   1/1     Running   0          5m19s
PS C:\Temp\example-voting-app-kubernetes (main)> kubectl logs worker-app-deploy-6dbf88866b-t8285
Connected to db
Found redis at 10.100.195.177
Connecting to redis
PS C:\Temp\example-voting-app-kubernetes (main)> kubectl apply -f voting-app-deploy.yaml
deployment.apps/voting-app-deploy created
PS C:\Temp\example-voting-app-kubernetes (main)> kubectl apply -f voting-app-service.yaml
service/voting-service created
PS C:\Temp\example-voting-app-kubernetes (main)> kubectl apply -f result-app-deploy.yaml
deployment.apps/result-app-deploy created
PS C:\Temp\example-voting-app-kubernetes (main)> kubectl apply -f result-app-service.yaml
service/result-service created
PS C:\Temp\example-voting-app-kubernetes (main)> kubectl get pods
NAME                                 READY   STATUS    RESTARTS   AGE
postgres-deploy-55db97fbd9-5vx5m     1/1     Running   0          9m28s
redis-deploy-598c448457-dxqhl        1/1     Running   0          9m11s
result-app-deploy-6f8485755-b5q8r    1/1     Running   0          63s
voting-app-deploy-5cb7bc8558-vdhf5   1/1     Running   0          78s
worker-app-deploy-6dbf88866b-t8285   1/1     Running   0          7m30s
```
</details>

## 3-Node Kubeadm cluster running on Ubuntu 22.04

* Kubernetes v1.25
* Nodes running on Hyper-V VMs on the local network
* `kubectl` running from the same Windows machine as above (just changed the context)

<details>
<summary>Expand for installation log</summary>

**Cluster Configuration**

```
PS C:\Temp\example-voting-app-kubernetes (main)> kubectl get nodes -o wide
NAME         STATUS ROLES         VERSION   INTERNAL-IP     OS-IMAGE            KERNEL-VERSION     CONTAINER-RUNTIME
controlplane Ready  control-plane v1.25.0   192.168.230.15  Ubuntu 22.04.1 LTS  5.15.0-71-generic  containerd://1.5.9-0ubuntu3.1
worker1      Ready  <none>        v1.25.0   192.168.230.16  Ubuntu 22.04.1 LTS  5.15.0-71-generic  containerd://1.5.9-0ubuntu3.1
worker2      Ready  <none>        v1.25.0   192.168.230.17  Ubuntu 22.04.1 LTS  5.15.0-71-generic  containerd://1.5.9-0ubuntu3.1
```

**Install Log**

```
PS C:\Temp\example-voting-app-kubernetes (main)> kubectl apply -f postgres-deploy.yaml
deployment.apps/postgres-deploy created
PS C:\Temp\example-voting-app-kubernetes (main)> kubectl apply -f postgres-service.yaml
service/db created
PS C:\Temp\example-voting-app-kubernetes (main)> kubectl apply -f redis-deploy.yaml
deployment.apps/redis-deploy created
PS C:\Temp\example-voting-app-kubernetes (main)> kubectl apply -f redis-service.yaml
service/redis created
PS C:\Temp\example-voting-app-kubernetes (main)> kubectl get pods
NAME                              READY   STATUS    RESTARTS   AGE
postgres-deploy-d9ddc956f-5wtvp   1/1     Running   0          3m7s
redis-deploy-744ff4944f-ltv26     1/1     Running   0          2m51s
PS C:\Temp\example-voting-app-kubernetes (main)> kubectl apply -f worker-app-deploy.yaml
deployment.apps/worker-app-deploy created
PS C:\Temp\example-voting-app-kubernetes (main)> kubectl get pods
NAME                                READY   STATUS    RESTARTS   AGE
postgres-deploy-d9ddc956f-5wtvp     1/1     Running   0          5m47s
redis-deploy-744ff4944f-ltv26       1/1     Running   0          5m31s
worker-app-deploy-bbdd88cdd-vszg4   1/1     Running   0          2m25s
PS C:\Temp\example-voting-app-kubernetes (main)> kubectl logs worker-app-deploy-bbdd88cdd-vszg4
Connected to db
Found redis at 10.96.54.94
Connecting to redis
PS C:\Temp\example-voting-app-kubernetes (main)> kubectl apply -f voting-app-deploy.yaml
deployment.apps/voting-app-deploy created
PS C:\Temp\example-voting-app-kubernetes (main)> kubectl apply -f voting-app-service.yaml
service/voting-service created
PS C:\Temp\example-voting-app-kubernetes (main)> kubectl apply -f result-app-deploy.yaml
deployment.apps/result-app-deploy created
PS C:\Temp\example-voting-app-kubernetes (main)> kubectl apply -f result-app-service.yaml
service/result-service created
PS C:\Temp\example-voting-app-kubernetes (main)> kubectl get pods
NAME                                 READY   STATUS    RESTARTS   AGE
postgres-deploy-d9ddc956f-5wtvp      1/1     Running   0          7m14s
redis-deploy-744ff4944f-ltv26        1/1     Running   0          6m58s
result-app-deploy-5bd6cd48f5-nfw7x   1/1     Running   0          52s
voting-app-deploy-85c4dc78d-nzq4d    1/1     Running   0          62s
worker-app-deploy-bbdd88cdd-vszg4    1/1     Running   0          3m52s
PS C:\Temp\example-voting-app-kubernetes (main)> kubectl get svc
NAME             TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
db               ClusterIP   10.96.208.9     <none>        5432/TCP       7m17s
kubernetes       ClusterIP   10.96.0.1       <none>        443/TCP        261d
nginx-ssl        ClusterIP   10.96.111.71    <none>        80/TCP         213d
nginx-test       ClusterIP   10.96.68.225    <none>        80/TCP         216d
redis            ClusterIP   10.96.54.94     <none>        6379/TCP       7m5s
result-service   NodePort    10.96.81.209    <none>        80:30005/TCP   60s
voting-service   NodePort    10.96.132.164   <none>        80:30004/TCP   69s
```

Now you can connect using the nodeport to the IP of any of the cluster members.
</details>