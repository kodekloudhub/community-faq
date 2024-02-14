# CKA vs. CKAD

Many people ask about this. Here we set out what is in each curricumlum and what is common. Where an item is in both CKA and CKAD, the courses normally share the same videos and labs.

The categories here do not reflect the domains in the actual exam, because the domains are different. A particular concept appears in one domain in CKA and another in CKAD. These categories attempt only to compare the individual concepts more or less at lecture/lab level. The important thing is that you cover all the concepts.

## Workloads/Services

| Concept               | CKA                | CKAD               |
|-----------------------|--------------------|--------------------|
| Pod                   | :heavy_check_mark: | :heavy_check_mark: |
| Replicaset            | :heavy_check_mark: | :heavy_check_mark: |
| Deployment            | :heavy_check_mark: | :heavy_check_mark: |
| StatefulSet           |                    | :heavy_check_mark: |
| DaemonSet             | :heavy_check_mark: |                    |
| Job                   |                    | :heavy_check_mark: |
| CronJob               |                    | :heavy_check_mark: |
| Service               | :heavy_check_mark: | :heavy_check_mark: |
| Headless Service      |                    | :heavy_check_mark: |
| Namespace             | :heavy_check_mark: | :heavy_check_mark: |
| Ingress               | :heavy_check_mark: | :heavy_check_mark: |
| Multi Container Pods  | :heavy_check_mark: | :heavy_check_mark: |
| Init Containers       | :heavy_check_mark: | :heavy_check_mark: |

## Configuration

| Concept               | CKA                | CKAD               |
|-----------------------|--------------------|--------------------|
| Secret                | :heavy_check_mark: | :heavy_check_mark: |
| ConfigMap             | :heavy_check_mark: | :heavy_check_mark: |
| Environment Vars      | :heavy_check_mark: | :heavy_check_mark: |
| Command and Arguments | :heavy_check_mark: | :heavy_check_mark: |
| Security Contexts     | :heavy_check_mark: | :heavy_check_mark: |
| Resource Reqs/Limits  | :heavy_check_mark: | :heavy_check_mark: |


## Scheduling/Deploying

| Concept                | CKA                | CKAD               |
|------------------------|--------------------|--------------------|
| Labels & Selectors     | :heavy_check_mark: | :heavy_check_mark: |
| Annotations            | :heavy_check_mark: | :heavy_check_mark: |
| Manual Scheduling      | :heavy_check_mark: |                    |
| kube-scheduler         | :heavy_check_mark: |                    |
| Multiple Schedulers    | :heavy_check_mark: |                    |
| Static Pods            | :heavy_check_mark: |                    |
| Node Selectors         | :heavy_check_mark: | :heavy_check_mark: |
| Taints & Tolerations   | :heavy_check_mark: | :heavy_check_mark: |
| Affinity/Anti-Affinity | :heavy_check_mark: | :heavy_check_mark: |
| Deployment Strategies  |                    | :heavy_check_mark: |
| Rolling Updates        | :heavy_check_mark: | :heavy_check_mark: |
| Helm                   |                    | :heavy_check_mark: |

## Storage

| Concept                 | CKA                | CKAD               |
|-------------------------|--------------------|--------------------|
| PersistentVolume        | :heavy_check_mark: | :heavy_check_mark: |
| PersistentVolumeClaim   | :heavy_check_mark: | :heavy_check_mark: |
| VolumeClaimTemplate     |                    | :heavy_check_mark: |
| HostPath volume         | :heavy_check_mark: |                    |
| EmptyDir volume         | :heavy_check_mark: | :heavy_check_mark: |
| StorageClass (creating) | :heavy_check_mark: |                    |
| StorageClass (using)    | :heavy_check_mark: | :heavy_check_mark: |
| Storage in Docker       | :heavy_check_mark: | :heavy_check_mark: |

## Security

| Concept            | CKA                | CKAD               |
|--------------------|--------------------|--------------------|
| ServiceAccount     | :heavy_check_mark: | :heavy_check_mark: |
| Role               | :heavy_check_mark: | :heavy_check_mark: |
| RoleBinding        | :heavy_check_mark: | :heavy_check_mark: |
| ClusterRole        | :heavy_check_mark: | :heavy_check_mark: |
| ClusterRoleBinding | :heavy_check_mark: | :heavy_check_mark: |
| NetworkPolicy      | :heavy_check_mark: | :heavy_check_mark: |
| Certificate API    | :heavy_check_mark: |                    |
| KUBECONFIG         | :heavy_check_mark: | :heavy_check_mark: |
| API groups         |                    | :heavy_check_mark: |
| API versions       |                    | :heavy_check_mark: |
| API deprecations   |                    | :heavy_check_mark: |
| Admission Controllers |                    | :heavy_check_mark: |
| Custom Resources   |                    | :heavy_check_mark: |
| Operators          |                    | :heavy_check_mark: |

## Observability

| Concept                      | CKA                | CKAD               |
|------------------------------|--------------------|--------------------|
| Logging                      | :heavy_check_mark: | :heavy_check_mark: |
| Monitoring                   | :heavy_check_mark: | :heavy_check_mark: |
| Managing Application Logs    | :heavy_check_mark: |                    |
| EmptyDir volume              | :heavy_check_mark: | :heavy_check_mark: |
| Probes (readiness, liveness) |                    | :heavy_check_mark: |

## Cluster Setup and Maintenance

These topics are CKA only

* Cluster Install - Never seen this tested in exam. It would take far longer than 6 min average time per question, but doesn't mean to say that it never will be, therefore you should *not* skip it! What you certainly won't have to do is to provision virtual machines. That is a Linux SA topic and is only presented here so that you can install your own cluster.
* Cluster Upgrade
* etcd architecture, backup and restore
* Kube Proxy
* CoreDNS

## Troubleshooting

These topics are CKA only

* Application failure
* Control plane failure
* Worker Node failure