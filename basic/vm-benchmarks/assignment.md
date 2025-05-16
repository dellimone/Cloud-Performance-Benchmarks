# Final Exam Exercise: Cloud Computing Performance Testing

## Objective

Evaluate and compare the performance of virtual machines (VMs).

---

## General Instructions

- Students can choose any Linux distribution for their virtual machines and containers.
- Any virtualization and containerization system may be used; **VirtualBox** and **Docker** are recommended.
- Use performance testing tools discussed during the lectures such as **HPL (High-Performance Linpack)**, **stress-ng**, and **sysbench**, **IOZone**, etc.
- **Optionally**, test I/O performance on both **local filesystems** and **NFS filesystems**.
- **Optionally**, test performance of the host machine (when possible).

---

## Virtual Machines Performance Test

### Setup

1. Create a set of virtual machines (e.g., 2-3 VMs).
2. Connect them using a virtual switch and local IPs.
3. Allocate limited resources to each VM (e.g., 2 CPUs and 2GB of RAM).

### Performance Tests

- **CPU Test**: Use **HPC Challenge Benchmark** for high-performance computation benchmarking (availabe for Ubuntu).
- **General System Test**: Use **stress-ng** or **sysbench** to evaluate CPU and memory performance.
- **Disk I/O Test**: Use `IOZone` to test local filesystem I/O. Optionally, configure an NFS filesystem and test its I/O performance.
- **Network Test**: Use tools like `iperf` or `netcat` to measure network throughput and latency between VMs.

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
