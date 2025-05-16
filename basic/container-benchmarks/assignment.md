# Final Exam Exercise: Cloud Computing Performance Testing

## Objective

Evaluate and compare the performance of containers.

---

## General Instructions

- Students can choose any Linux distribution for their virtual machines and containers.
- Any virtualization and containerization system may be used; **VirtualBox** and **Docker** are recommended.
- Use performance testing tools discussed during the lectures such as **HPL (High-Performance Linpack)**, **stress-ng**, and **sysbench**, **IOZone**, etc.
- **Optionally**, test I/O performance on both **local filesystems** and **NFS filesystems**.
- **Optionally**, test performance of the host machine (when possible).

---

## Containers Performance Test

### Setup

1. Create a Docker Compose file to define a set of containers (e.g., 2-4 containers).
2. Connect the containers using internal Docker network.
3. Limit resources for each container using Docker Compose options (e.g., 2 CPUs and 2GB of RAM).

### Performance Tests

- **CPU Test**: Run **HPC Challenge Benchmark** for CPU performance and/or **stress-ng** or **sysbench** for general system performance.
- **Disk I/O Test**: Use `IOZone` to test local filesystem performance within containers.
- **Network Test**: Use `iperf` or `netcat` to measure network throughput between containers.

---

## Final Comparison

### Analyze

- Compare the performance results across VMs, containers, and optionally with the host machine.
- Discuss the impact of resource allocation, virtualization overhead, and network/file system efficiency.

### Deliverables

- Submit a report containing:
  - Steps for setting up VMs and containers.
  - Performance metrics (HPL, stress-ng, sysbench, disk I/O, and network throughput).
  - Observations and analysis of the performance tests.
