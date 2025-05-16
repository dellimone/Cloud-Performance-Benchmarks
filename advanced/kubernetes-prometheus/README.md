# Kubernetes HPL Benchmarking

This project provides a simple and automated way to set up a Kubernetes cluster using Vagrant and Ansible. The setup includes one control plane node and two worker nodes.

## Project Structure

```bash
.
├── kubernetes-setup
│   ├── join-command
│   ├── k8s-playbook.yaml
│   └── playground_kubeconfig.yaml
├── README.md
└── Vagrantfile
```

## Prerequisites

Before you begin, ensure you have the following installed:

- **Vagrant**: A tool for building and managing virtual machine environments.

- vagrant libvirt plugin

- **Ansible**: An automation engine for IT automation.

- **Virsh** The provided Vagrantfile is configured for libvirt, but you can modify it for your preferred provider.

- **Helm**

- docker 

## Setup
**Build the docker image for the hpl test.**

```bash
> cd hpl
> docker build -t hpl-benchmark .
```

**Save the docker image**
```bash
> docker save -o hpl-benchmark.tar hpl-benchmark:latest
```

**Start the Vagrant environment:**

```bash
> vagrant up --provider=libvirt --no-parallel
```

## Accessing the Kubernetes Cluster

Once the vagrant up command completes successfully, you can interact with your Kubernetes cluster using `kubectl`. 

For using `kubectl` without accessing the control node set the `KUBECONFIG` environment variable in your host.

```bash
export KUBECONFIG=$(pwd)/kubernetes-setup/playground_kubeconfig.yaml
```

## Verify the cluster status

You should be able to see the status of your nodes.

```bash
> kubectl get nodes
NAME          STATUS   ROLES           AGE     VERSION
kube-01       Ready    <none>          3m22s   v1.32.4
kube-02       Ready    <none>          72s     v1.32.4
kube-master   Ready    control-plane   5m33s   v1.32.4
```

## Install Kube-Prometheus-stack

First, register the chart’s repository in your Helm client:

```bash
> helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
"prometheus-community" has been added to your repositories
```

Next, update your repository lists to discover the chart:

```bash
> helm repo update
```

Now you can run the following command to deploy the chart into a new namespace in your cluster:

```bash
> helm install kube-prometheus-stack \
  --create-namespace \
  --namespace kube-prometheus-stack \
  prometheus-community/kube-prometheus-stack
```

It can take a couple of minutes for the chart’s components to start. Run the following command to check how they’re progressing:

```bash
kubectl -n kube-prometheus-stack get pods
NAME                                                       READY   STATUS    RESTARTS      AGE
alertmanager-kube-prometheus-stack-alertmanager-0          2/2     Running   1 (66s ago)   83s
kube-prometheus-stack-grafana-5cd658f9b4-cln2c             3/3     Running   0             99s
kube-prometheus-stack-kube-state-metrics-b64cf5876-52j8l   1/1     Running   0             99s
kube-prometheus-stack-operator-754ff78899-669k6            1/1     Running   0             99s
kube-prometheus-stack-prometheus-node-exporter-vdgrg       1/1     Running   0             99s
prometheus-kube-prometheus-stack-prometheus-0              2/2     Running   0             83s
```

Once all the Pods show as Running, your monitoring stack is ready to use. The data exposed by the exporters will be automatically scraped by Prometheus

## Open Grafana dashboards

Start a new Kubectl port forwarding session to access the Grafana UI. Use port 80 as the target because this is what the Grafana service binds to.

You can map it to a different local port, such as 8080, in this example:

```bash
kubectl port-forward -n kube-prometheus-stack svc/kube-prometheus-stack-grafana 8080:80
Forwarding from 127.0.0.1:8080 -> 3000
Forwarding from [::1]:8080 -> 3000
```

Next visit `http://localhost:8080` in your browser. You’ll see the Grafana login page. The default user account is `admin` with a password of `prom-operator`.

Viewing the resource consumption of individual pods with “Kubernetes / Compute Resources / Pod.

## Run HPL test

the hpl test is deployed with the `hpl-single.yaml` manifest. before running the test you must set the `HPL.dat` file in `/hpl` and create the configmap.

**Create Config map**

```bash
kubectl create configmap hpl-config --from-file=./hpl/HPL.dat -n hpl-benchmarks
```

**Check Config map**
```bash
kubectl get configmaps -n hpl-benchmarks
```

**Delete config map**

```bash
kubectl delete configmap hpl-config -n hpl-benchmarks
```

**Run hpl test on a single pod**

```bash
kubectl apply -f hpl/hpl-single.yaml
```

**Run a standalone hpl test on each node**

```bash
kubectl apply -f hpl/hpl-double.yaml
```

## Troubleshooting
**Pending status indefinitely**
```bash
> kubectl get pods -n hpl-benchmarks
NAME            READY   STATUS      RESTARTS   AGE
hpl-benchmark   0/1     Pending   0          52s
> kubectl describe pod hpl-benchmark -n hpl-benchmarks
...
Events:
  Type     Reason       Age                 From               Message
  ----     ------       ----                ----               -------
  Normal   Scheduled    107s                default-scheduler  Successfully assigned hpl-benchmarks/hpl-benchmark to kube-01
  Warning  FailedMount  43s (x8 over 107s)  kubelet            MountVolume.SetUp failed for volume "hpl-config-volume" : configmap "hpl-config" not found
```

The pod `hpl-benchmark` in the `hpl-benchmarks` namespace is failing to start due to a `FailedMount` error.  This means that the pod is configured to mount a volume named `hpl-config-volume`, which relies on a Kubernetes ConfigMap named `hpl-config`. However, the Kubernetes cluster cannot find a ConfigMap with that name in the `hpl-benchmarks` namespace.

To fix this issue, you need to create the `hpl-config` ConfigMap in the `hpl-benchmarks` namespace.

```bash
> kubectl describe pod hpl-benchmark -n hpl-benchmarks
...
Events:
  Type     Reason            Age   From               Message
  ----     ------            ----  ----               -------
  Warning  FailedScheduling  47s   default-scheduler  0/3 nodes are available: 1 node(s) had untolerated taint {node-role.kubernetes.io/control-plane: }, 2 Insufficient cpu. preemption: 0/3 nodes are available: 1 Preemption is not helpful for scheduling, 2 No preemption victims found for incoming pod.
```
Based on the `Events` section of the `kubectl describe pod` output for `hpl-benchmark`, the pod failed to schedule due to two primary reasons across the three available nodes:

1. **Untolerated Taint:** One node in the cluster has a taint `node-role.kubernetes.io/control-plane`. This is the control plane nodes. The `hpl-benchmark` pod does not have this toleration, making that node unavailable for scheduling.
2. **Insufficient CPU:** The other two nodes in the cluster do not have enough available CPU resources to meet the requirements of the `hpl-benchmark` pod.

**Image error**
```bash
> kubectl get pods -n hpl-benchmarks
NAME            READY   STATUS              RESTARTS   AGE
hpl-benchmark   0/1     ErrImageNeverPull   0          95s
> kubectl describe pod hpl-benchmark -n hpl-benchmarks
...
Events:
  Type     Reason             Age               From               Message
  ----     ------             ----              ----               -------
  Normal   Scheduled          21s               default-scheduler  Successfully assigned hpl-benchmarks/hpl-benchmark to kube-01
  Warning  ErrImageNeverPull  8s (x3 over 21s)  kubelet            Container image "hpl-benchmark:latest" is not present with pull policy of Never
  Warning  Failed             8s (x3 over 21s)  kubelet            Error: ErrImageNeverPull
```
The error `ErrImageNeverPull` indicates that the container image required by the pod `hpl-benchmark:latest` was not found on the node where the pod was scheduled, and the pod's container definition has the `imagePullPolicy` explicitly set to `Never`. Because Kubernetes is instructed _not_ to pull the image from a registry when this policy is set and the image is not locally available, the container creation fails.

```bash
> kubectl get pods -n hpl-benchmarks
NAME            READY   STATUS   RESTARTS   AGE
hpl-benchmark   0/1     Error    0          17s
> kubectl logs hpl-benchmark -n hpl-benchmarks
--------------------------------------------------------------------------
There are not enough slots available in the system to satisfy the 16
slots that were requested by the application:

  ./xhpl
...
```
Analysis of the pod logs indicates that the HPL benchmark failed because it attempted to allocate 16 processing slots (likely corresponding to cores or threads), but the system did not have sufficient resources available to fulfill this request. The pod entered an `Error` state as a result

**OOMKilled**

```bash
> kubectl get pods -n hpl-benchmarks
NAME            READY   STATUS      RESTARTS   AGE
hpl-benchmark   0/1     OOMKilled   0          52s
```

The `OOMKilled` status stands for **Out Of Memory Killed**. This means that the Kubernetes node where your pod was running detected that the pod was consuming more memory than it was allowed (either exceeding its defined memory limit or, if no limit was set, consuming excessive memory that threatened the node's stability).