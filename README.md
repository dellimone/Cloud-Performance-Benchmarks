# Cloud Performance Benchmarks

## Project Overview

This project is a comprehensive cloud computing performance benchmarking suite designed to evaluate and compare the performance characteristics of different virtualization, containerization, and orchestration technologies. The project implements systematic performance testing across multiple deployment scenarios to understand the overhead and efficiency of various cloud computing approaches.

## Overall Goal

The primary objective of this project is to conduct a thorough performance analysis and comparison between:

1. **Virtual Machines (VMs)** - Using both VirtualBox and libvirt/KVM hypervisors
2. **Containers** - Using Docker containerization technology
3. **Advanced Network Configurations** - Testing various inter-namespace connection methods
4. **Kubernetes Orchestration** - Performance monitoring of HPC workloads in Kubernetes clusters

The project aims to measure and compare key performance metrics including CPU performance, memory throughput, disk I/O capabilities, and network performance across these different virtualization and orchestration approaches.

## Project Structure

The project is organized into three main categories:

### Basic Performance Benchmarks (`basic/`)
- **VM Benchmarks**: Performance testing of virtual machines using VirtualBox and libvirt
- **Container Benchmarks**: Performance testing of Docker containers
- Tests include CPU (HPL/LINPACK), memory, disk I/O, and network performance metrics

### Advanced Benchmarks (`advanced/`)

#### Network Performance (`connection-benchmarking/`)
- Advanced network performance testing using Linux network namespaces
- Compares three different inter-namespace connection methods:
  - Direct veth pairs
  - veth pairs connected via a single bridge
  - veth pairs on separate bridges connected via VXLAN tunnel
- Measures bandwidth and latency for each connection method

#### Kubernetes Performance Monitoring (`kubernetes-prometheus/`)
- Kubernetes cluster setup with automated provisioning using Vagrant and Ansible
- Integration of Kube-Prometheus stack for comprehensive monitoring (Prometheus, Grafana, Alertmanager)
- HPL (High-Performance LINPACK) benchmarking within Kubernetes pods
- Performance monitoring and analysis of containerized HPC workloads
- Resource utilization tracking (CPU, memory, network, disk I/O) during intensive workloads

### Project Report (`report/`)
- Comprehensive analysis and findings from all benchmark tests
- Performance comparisons and technical discussions
- Complete documentation of methodologies and results

## Key Performance Areas Tested

1. **CPU Performance**: High-Performance LINPACK (HPL) benchmarks and stress testing
2. **Memory Performance**: Memory bandwidth and latency testing using various tools
3. **Disk I/O Performance**: Filesystem and block-level I/O testing with IOZone and other tools
4. **Network Performance**: Bandwidth and latency measurements using iperf and ping
5. **Network Architecture Performance**: Comparison of different network connection topologies
6. **Kubernetes Orchestration Overhead**: Performance impact of container orchestration
7. **Resource Monitoring**: Real-time performance monitoring using Prometheus and Grafana

## Technologies Used

- **Virtualization**: VirtualBox, libvirt/KVM, QEMU
- **Containerization**: Docker, Docker Compose
- **Container Orchestration**: Kubernetes
- **Monitoring Stack**: Prometheus, Grafana, Alertmanager (Kube-Prometheus-stack)
- **Networking**: Linux network namespaces, veth pairs, bridges, VXLAN
- **Benchmarking Tools**: HPL (High-Performance LINPACK), stress-ng, sysbench, iperf, IOZone
- **Infrastructure**: Vagrant, Ansible, Helm for automated provisioning
- **Package Management**: Helm for Kubernetes application deployment

## Academic Context

This project appears to be part of a cloud computing course final examination, focusing on practical performance analysis of virtualization technologies and modern container orchestration platforms. It demonstrates hands-on experience with:

- Traditional virtualization approaches (VMs)
- Modern containerization (Docker)
- Container orchestration (Kubernetes)
- Advanced networking configurations
- Production-grade monitoring solutions

The comprehensive nature of the benchmarks provides valuable insights into the performance implications and trade-offs of choosing different virtualization, containerization, and orchestration strategies in cloud environments, from basic VM setups to sophisticated Kubernetes clusters with monitoring infrastructure.