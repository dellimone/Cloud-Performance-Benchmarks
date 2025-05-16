# Exercise 2: Kubernetes Performance Monitoring with Prometheus

**Objective**: Evaluate the performance of a Kubernetes cluster while running

a high-performance computing (HPC) workload using the High-Performance

Linpack (HPL) test.

**Setup**:

1. Install a Kubernetes cluster on a set of machines or use an existing one.

2. Provision the Kube-Prometheus stack, including Prometheus, Grafana and Alertmanager.

3. Create a Pod running the HPL test, configured to utilize multiple CPUs and memory.

**Monitoring and Analysis**:

1. Monitor the behavior of the Kubernetes node(s) while the HPL test is running using the Kube-Prometheus stack.

2. Observe metrics such as CPU utilization, memory usage, network throughput, and disk I/O.

3. Analyze the performance data to identify any bottlenecks or issues with the node(s).

4. If the node(s) do not function correctly during the test (e.g., due to resource exhaustion), describe how to fix the problem.

**Deliverables**:

A detailed report containing:

- Steps for setting up the Kubernetes cluster and provisioning the Kube-Prometheus stack

- Description of the HPL test Pod configuration and execution

- Analysis of the performance data, including identification of any bottlenecks or issues

- Discussion on how to fix any problems encountered during the test

- Screenshots of Prometheus and Grafana dashboards showing relevant metrics
