# jsonpath and custom-columns in kubectl

Lots of people ask questions about jsonpath. 

* Should, I learn it?

    Yes absolutely! If you are a working DevOps/SRE and you need to create automations based on information gathered from deployed resources, this is the way you gather that information in scripts. If you aspire to do the CKS certification, you can speed up the resolution of many exam questions by using creating one-line scripts involving jsonpath queries.

* Why is it so difficult?

    It really isn't once you understand the relationship between the resource YAML and the query syntax, which I hope to demystify a bit here.


Now let's look at a complete running pod definition and how we can obtain *any* of the information present in the form of jsonpath. Expand the following to see the jsonpath expression that targets each field in this running pod definition. Note in the `annotations` of this pod how we specify a field that has a name that itself contains dots.

Notice the relationship between the path to and the position of each property in the YAML. Note also how lists are handled with a list index number in square brackets.

<details>
<summary>Expand</summary>

```yaml
apiVersion: v1                                                      # .apiVersion
kind: Pod                                                           # .kind
metadata:                                                           # .metadata
  annotations:                                                      # .metadata.annotations
    cni.projectcalico.org/podIP: 192.168.1.3/32                     # .metadata.annotations.cni\.projectcalico\.org/podIP
  creationTimestamp: "2023-10-17T04:26:37Z"                         # .metadata.creationTimestamp
  labels:                                                           # .metadata.labels
    run: test                                                       # .metadata.labels.run
  name: test                                                        # .metadata.name
  namespace: default                                                # .metadata.namespace
  resourceVersion: "2709"                                           # .metadata.resourceVersion
  uid: f2d4e6db-1523-4124-9e0b-b3a05e21ca4e                         # .metadata.uid
spec:                                                               # .spec
  containers:                                                       # .spec.containers
  - image: nginx                                                    # .spec.containers[0].image
    imagePullPolicy: Always                                         # .spec.containers[0].imagePullPolicy
    name: test                                                      # .spec.containers[0].name
    resources: {}                                                   # .spec.containers[0].resources
    terminationMessagePath: /dev/termination-log                    # .spec.containers[0].terminationMessagePath
    terminationMessagePolicy: File                                  # .spec.containers[0].terminationMessagePolicy
    volumeMounts:                                                   # .spec.containers[0].volumeMounts
    - mountPath: /var/run/secrets/kubernetes.io/serviceaccount      # .spec.containers[0].volumeMounts[0].mountPath
      name: kube-api-access-48rbv                                   # .spec.containers[0].volumeMounts[0].name
      readOnly: true                                                # .spec.containers[0].volumeMounts[0].readOnly
  dnsPolicy: ClusterFirst                                           # .spec.dnsPolicy
  enableServiceLinks: true                                          # .spec.enableServiceLinks
  nodeName: node01                                                  # .spec.nodeName
  preemptionPolicy: PreemptLowerPriority                            # .spec.preemmtionPolicy
  priority: 0                                                       # .spec.priority
  restartPolicy: Always                                             # .spec.restartPolicy
  schedulerName: default-scheduler                                  # .spec.schedulerName
  securityContext: {}                                               # .spec.securityContext
  serviceAccount: default                                           # .spec.serviceAccount
  serviceAccountName: default                                       # .spec.serviceAccountName
  terminationGracePeriodSeconds: 30                                 # .spec.terminationGracePeriodSeconds
  tolerations:                                                      # .spec.tolerations
  - effect: NoExecute                                               # .spec.tolerations[0].effect
    key: node.kubernetes.io/not-ready                               # .spec.tolerations[0].key
    operator: Exists                                                # .spec.tolerations[0].operator
    tolerationSeconds: 300                                          # .spec.tolerations[0].tolerationSeconds
  - effect: NoExecute                                               # .spec.tolerations[1].effect
    key: node.kubernetes.io/unreachable                             # .spec.tolerations[1].key
    operator: Exists                                                # .spec.tolerations[1].operator
    tolerationSeconds: 300                                          # .spec.tolerations[1].tolerationSeconds
  volumes:                                                          # .spec.volumes
  - name: kube-api-access-48rbv                                     # .spec.volumes[0].name
    projected:                                                      # .spec.volumes[0].projected
      defaultMode: 420                                              # .spec.volumes[0].projected.defaultMode
      sources:                                                      # .spec.volumes[0].projected.sources
      - serviceAccountToken:                                        # .spec.volumes[0].projected.sources[0].serviceAccountToken
          expirationSeconds: 3607                                   # .spec.volumes[0].projected.sources[0].serviceAccountToken.expirationSeconds
          path: token                                               # .spec.volumes[0].projected.sources[0].serviceAccountToken.path
      - configMap:                                                  # .spec.volumes[0].projected.sources[1].configMap
          items:                                                    # .spec.volumes[0].projected.sources[1].configMap.items
          - key: ca.crt                                             # .spec.volumes[0].projected.sources[1].configMap.items[0].key
            path: ca.crt                                            # .spec.volumes[0].projected.sources[1].configMap.items[0].path
          name: kube-root-ca.crt                                    # .spec.volumes[0].projected.sources[1].configMap.name
      - downwardAPI:                                                # .spec.volumes[0].projected.sources[2].downwardAPI
          items:                                                    # .spec.volumes[0].projected.sources[2].downwardAPI.items
          - fieldRef:                                               # .spec.volumes[0].projected.sources[2].downwardAPI.items[0].fieldRef
              apiVersion: v1                                        # .spec.volumes[0].projected.sources[2].downwardAPI.items[0].fieldRef.apiVersion
              fieldPath: metadata.namespace                         # .spec.volumes[0].projected.sources[2].downwardAPI.items[0].fieldRef.fieldPath
            path: namespace                                         # .spec.volumes[0].projected.sources[2].downwardAPI.items[0].path
status:                                                             # .status
  conditions:                                                       # .status.conditions
  - lastProbeTime: null                                             # .status.conditions[0].lastProbeTime
    lastTransitionTime: "2023-10-17T04:26:37Z"                      # .status.conditions[0].lastTransitionTime
    status: "True"                                                  # .status.conditions[0].status
    type: Initialized                                               # .status.conditions[0].type
  - lastProbeTime: null                                             # .status.conditions[1].lastProbeTime
    lastTransitionTime: "2023-10-17T04:26:43Z"                      # .status.conditions[1].lastTransitionTime
    status: "True"                                                  # .status.conditions[1].status
    type: Ready                                                     # .status.conditions[1].type
  - lastProbeTime: null                                             # .status.conditions[2].lastProbeTime
    lastTransitionTime: "2023-10-17T04:26:43Z"                      # .status.conditions[2].lastTransitionTime
    status: "True"                                                  # .status.conditions[2].status
    type: ContainersReady                                           # .status.conditions[2].type
  - lastProbeTime: null                                             # .status.conditions[3].lastProbeTime
    lastTransitionTime: "2023-10-17T04:26:37Z"                      # .status.conditions[3].lastTransitionTime
    status: "True"                                                  # .status.conditions[3].status
    type: PodScheduled                                              # .status.conditions[3].type
  containerStatuses:                                                # .status.containerStatuses
  - containerID: containerd://63cd91aa4c25de                        # .status.containerStatuses[0].containerID
    image: docker.io/library/nginx:latest                           # .status.containerStatuses[0].image
    imageID: docker.io/library/nginx@sha256:b4af4f8b647             # .status.containerStatuses[0].imageID
    lastState: {}                                                   # .status.containerStatuses[0].lastState
    name: test                                                      # .status.containerStatuses[0].name
    ready: true                                                     # .status.containerStatuses[0].ready
    restartCount: 0                                                 # .status.containerStatuses[0].restartCount
    started: true                                                   # .status.containerStatuses[0].started
    state:                                                          # .status.containerStatuses[0].state
      running:                                                      # .status.containerStatuses[0].state.running
        startedAt: "2023-10-17T04:26:42Z"                           # .status.containerStatuses[0].state.running.startedAt
  hostIP: 172.30.2.2                                                # .status.hostIP
  phase: Running                                                    # .status.phase
  podIP: 192.168.1.3                                                # .status.podIP
  podIPs:                                                           # .status.podIPs
  - ip: 192.168.1.3                                                 # .status.podIPs[0].ip
  qosClass: BestEffort                                              # .status.qosClass
  startTime: "2023-10-17T04:26:37Z"                                 # .status.startTime
```

</details>

Hopefully after studying this carefully you can see how to form the jsonpath expression for any field in the YAML output of a running resource. Use the same method for *any* resource you can get with `-o yaml`.

Note that if you put two dots `..` anywhere in a jsonpath query, then what will be returned is every occurrence of the property to the right of `..` that is found beneath what is on the left of `..`, no matter how deep in the hierarchy. Take care as this may give you more results than you need, or some unexpected ones.

Examples

*   Every property called image beneath `spec`

    ```
    .spec..image
    ```

    Output

    ```
    nginx
    ```

    The value is that of `spec.containers[0].image`

*   Every property called `image` in the entire manifest

    ```
    ..image
    ```

    Output

    ```
    nginx docker.io/library/nginx:latest
    ```

    There are two values returned here, separated by a space. Those are the values at the following jsonpaths

    * `spec.containers[0].image`
    * `status.containerStatuses[0].image`

*   Try this one for yourself!

    ```
    ..status
    ```

    There is *a lot* of output. Some reults are entire portions of the schema, and others are indiviual properties. Not that useful!

## Handling multiple results

If we run a kubectl command that returns more than one object, e.g. we do `kubectl get pods` rather than `kubectl get pod some-pod`, then we are going to get more than one result. kubectl returns multiple results as a list called `items`

In the following I have removed most of the properties for brevity to focus on the fact that we get a list of items when we do  we do `kubectl get pods` with no explicit pod name. I've only labelled a few properties - you should be able to determine others.

<details>
<summary>Expand</summary>

```yaml
apiVersion: v1
items:                          # .items
- apiVersion: v1
  kind: Pod
  metadata:
    name: pod1                  # .items[0].metadata.name
    namespace: default          # .items[0].metadata.namespace
  spec:
    containers:
    - image: nginx              # .items[0].spec.containers[0].image
      name: nginx
    - image: busybox            # .items[0].spec.containers[1].image
      name: sidecar
  status:
    hostIP: 172.30.1.2
    phase: Running
    podIP: 172.30.1.2
- apiVersion: v1
  kind: Pod
  metadata:
    name: pod2                  # .items[1].metadata.name
    namespace: default
  spec:
    containers:
      image: redis
      name: redis
  status:
    hostIP: 172.30.1.3
    phase: Running
    podIP: 172.30.1.3
kind: List
metadata:
  resourceVersion: ""
```

</details>

Examples

*   Every image in every container in the first pod

    ```
    .items[0].spec..image
    ```

    OR (more targeted)

    ```
    .items[0].spec.containers[*].image
    ```

*   Every image in *every* container

    ```
    .items[*].spec.containers[*].image
    ```

# custom-columns

Custom column expressions are also jsonpath. Some people ask why you never use `items` when forming a custom column definition. The reason is that a custom-columns expression is always targeting multiple results, there's not really much point on doing it for a single pod. Saying this, because we have multiple results, the `items` part of the query is implicit, therefore we can omit it.

So, given the multiple pod YAML list result in the section above, we could get all the pod names like this

```
kubectl get pods -o custom-columns=POD_NAME:.metadata.name
```

NOT

```
kubectl get pods -o custom-columns=POD_NAME:items[*].metadata.name
```

# Advanced

How do I make kubectl jsonpath output on separate lines?

For example, the following command extracts the podIP for every running Pod across all namespaces.

```
kubectl get pods -A -o jsonpath='{.items[*].status.podIP}'
```

It returns something like the following:

```
10.244.0.11 10.244.0.8 10.244.0.14 10.244.0.10 10.244.0.6 10.244.0.12 10.244.0.13 10.244.0.15 10.244.0.7 10.244.0.9 10.244.0.3 10.244.0.2 10.244.0.5 172.18.0.2 172.18.0.2 172.18.0.2 172.18.0.2 172.18.0.2 172.18.0.2 10.244.0.4
```
That’s not the friendliest output to work with, that’s for sure!

You can use the jsonpath `range` function to iterate over the list and tack on a new line after each element with `{"\n"}`.

```
kubectl get pods -A -o jsonpath='{range .items[*]}{.status.podIP}{"\n"}{end}'
```

This outputs:

```
10.244.0.11
10.244.0.8
10.244.0.14
10.244.0.10
10.244.0.6
10.244.0.12
10.244.0.13
10.244.0.15
10.244.0.7
10.244.0.9
10.244.0.3
10.244.0.2
10.244.0.5
172.18.0.2
172.18.0.2
172.18.0.2
172.18.0.2
172.18.0.2
172.18.0.2
10.244.0.4
```

Awesome! Now we can work with the output using all sorts of standard UNIX utilities that operate on new line (e.g. `sort`, `xargs`, `uniq`, etc.).

So, what just happened?

1.  `{range .items[*]}` - For each `item` in the items list
1.  `{.status.podIP}` - get `.status.podID` *for the current item*
1.  `{"\n"}` - print a newline character
1.  `{end}` - end of the range context.

This is just like using a for loop in programming

You can use any other plain text and/or get multiple fields in the same jsonpath query and format them nicely.

```
kubectl get pods -A -o jsonpath='{range .items[*]}{.metadata.namespace}{"/"}{.metadata.name}{","}{.status.podIP}{"\n"}{end}'
```

yields e.g.

```
default/fah-cpu-7c66fc7948-txvpg,10.244.0.7
default/fah-cpu-7c66fc7948-vzpbz,10.244.0.9
default/mando-57fff9d5f5-rdxrx,10.244.0.3
kube-system/coredns-66bff467f8-r9g25,10.244.0.2
kube-system/coredns-66bff467f8-xfd5k,10.244.0.5
kube-system/etcd-kind-control-plane,172.18.0.2
kube-system/kindnet-g6jvd,172.18.0.2
```