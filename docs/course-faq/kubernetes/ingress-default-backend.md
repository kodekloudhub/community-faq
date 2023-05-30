# Ingress Default Backend

This question is one of the most frequent of all.

In the CKAD ingress-networking-1 practice lab there is the following question

> Q11. If the requirement does not match any of the configured paths what service are the requests forwarded to?

This question is *specifically* about the ingress *resource* `ingress-wear-watch`. To answer it we need to look at the ingress resource manifest:

```
kubectl  get ingress -n app-space ingress-wear-watch -o yaml
```

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
    nginx.ingress.kubernetes.io/ssl-redirect: "false"
  creationTimestamp: "2023-05-30T05:38:51Z"
  generation: 1
  name: ingress-wear-watch
  namespace: app-space
  resourceVersion: "957"
  uid: 81a26891-2453-4aca-b1ae-747f4821cc25
spec:
  rules:
  - http:
      paths:
      - backend:
          service:
            name: wear-service
            port:
              number: 8080
        path: /wear
        pathType: Prefix
      - backend:
          service:
            name: video-service
            port:
              number: 8080
        path: /watch
        pathType: Prefix
status:
  loadBalancer:
    ingress:
    - ip: 10.103.3.205
```

Now there is something missing from the above relating to the answer to the above question.

```
controlplane ~ ➜  kubectl explain ingress.spec.defaultBackend
KIND:     Ingress
VERSION:  networking.k8s.io/v1

RESOURCE: defaultBackend <Object>

DESCRIPTION:
     DefaultBackend is the backend that should handle requests that don't match
     any rule. If Rules are not specified, DefaultBackend must be specified. If
     DefaultBackend is not set, the handling of requests that do not match any
     of the rules will be up to the Ingress controller.
```

The ingress resource has no `defaultBackend` defined, so that is why the answer is `No Service`.

But - you cry, I am seeing a 404 page presented, so how can the answer be `No Service`? Note the last sentence of the above explain command. Let's investigate that.


```
controlplane ~ ➜  kubectl get service -n app-space
NAME                      TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
default-backend-service   ClusterIP   10.110.165.219   <none>        80/TCP     8m5s
video-service             ClusterIP   10.106.252.39    <none>        8080/TCP   8m6s
wear-service              ClusterIP   10.96.168.62     <none>        8080/TCP   8m6s
```

Hmmm, a default backend service. We have learned that the ingress controller is somehow involved. Let's look into that:

1.  Find the ingress controller pod:

    ```
    controlplane ~ ➜  kubectl get po -n ingress-nginx
    NAME                                        READY   STATUS      RESTARTS   AGE
    ingress-nginx-admission-create-m764n        0/1     Completed   0          9m47s
    ingress-nginx-admission-patch-hrk9f         0/1     Completed   1          9m47s
    ingress-nginx-controller-6cc8dfc97c-lff8b   1/1     Running     0          9m47s
    ```
1.  Examine it

    ```
    kubectl get pod -n ingress-nginx ingress-nginx-controller-6cc8dfc97c-lff8b -o yaml
    ```

    ```yaml
    apiVersion: v1
    kind: Pod
    metadata:
    creationTimestamp: "2023-05-30T05:38:52Z"
    generateName: ingress-nginx-controller-6cc8dfc97c-
    labels:
        app.kubernetes.io/component: controller
        app.kubernetes.io/instance: ingress-nginx
        app.kubernetes.io/name: ingress-nginx
        pod-template-hash: 6cc8dfc97c
    name: ingress-nginx-controller-6cc8dfc97c-lff8b
    namespace: ingress-nginx
    ownerReferences:
    - apiVersion: apps/v1
        blockOwnerDeletion: true
        controller: true
        kind: ReplicaSet
        name: ingress-nginx-controller-6cc8dfc97c
        uid: 48903db8-12c4-4ca8-8b37-78cefbe081f3
    resourceVersion: "975"
    uid: c3837282-64fb-4bd5-b103-9b23de589227
    spec:
    containers:
    - args:
        - /nginx-ingress-controller
        - --publish-service=$(POD_NAMESPACE)/ingress-nginx-controller
        - --election-id=ingress-controller-leader
        - --watch-ingress-without-class=true
        - --default-backend-service=app-space/default-backend-service # <- LOOK HERE
        - --controller-class=k8s.io/ingress-nginx
        - --ingress-class=nginx
        - --configmap=$(POD_NAMESPACE)/ingress-nginx-controller
        - --validating-webhook=:8443
        - --validating-webhook-certificate=/usr/local/certificates/cert
        - --validating-webhook-key=/usr/local/certificates/key
    ```

The ingress *controller* owns the service `default-backend-service` in namespace `app-space`. It is providing the 404 page, *not* the `ingress-wear-watch` ingress resource.

