# Virtual machine benchmark

## Description

This project utilizes a Vagrantfile and an Ansible playbook to provision a specific network environment designed for performance benchmarking, particularly focusing on high-performance computing (HPC) workloads and shared storage performance.

The environment, as defined by the `Vagrantfile`, consists of the following virtual machines:

- **`server-00` (192.168.50.10):** This VM is designated and configured by the Ansible playbook as the central **NFS (Network File System) server**. Its primary role is to export a specific directory, making it available as shared storage across the network.
- **`node-00` (192.168.50.11):** This VM acts as a **worker machine**. It is configured by the Ansible playbook as an NFS client to access the shared storage provided by `server-00`. Additionally, this node is equipped with a variety of general benchmarking tools (such as stress-ng, sysbench, iozone3, iperf) and has a complete HPC environment (including custom-compiled OpenBLAS, OpenMPI, and the HPL LINPACK benchmark) set up within the `vagrant` user's home directory.

Both VMs are based on the `generic/ubuntu2004` box and are configured with a private network. 

The provisioned environment is equipped to perform a suite of performance benchmarks using the scripts located in the `scripts/` directory (as copied to `/home/vagrant/scripts/` on the worker nodes). These tests are designed to evaluate the key performance aspects of the deployed virtual machines and the network infrastructure connecting them.

The benchmark suite includes tests for:

- **CPU Performance:** These tests measure the processing capabilities of the worker nodes. They utilize `stress-ng` for various CPU-intensive workloads, including matrix operations and other computational tasks, as well as a general CPU benchmark from `sysbench`.
- **Memory Performance:** This category assesses the memory subsystem's speed and capacity. `stress-ng` is used to apply different types of memory pressure (VM, malloc, bigheap), and `sysbench` provides a dedicated memory bandwidth and latency test.
- **I/O Performance:** Focusing on storage performance, these tests evaluate how efficiently the system can handle disk read and write operations. Both `iozone` for filesystem-level testing and `fio` for more granular block-level I/O (specifically random writes in this setup) are used. Given the NFS configuration, these tests are particularly relevant for evaluating the performance of the shared storage mounted from the server.
- **Network Performance:** Essential for understanding the interconnectivity of the nodes, these tests measure network bandwidth using `iperf` and network latency using `ping` between the worker and server nodes.

## Project Structure

```bash
.
├── ansible
│   └── setup.yaml
├── assignment.md
├── hpl
│   └── HPL.dat
├── libvirt
│   └── Vagrantfile
├── README.md
├── results
│   ├── libvirt
│   └── virtualbox
├── scripts
│   ├── run_test.sh
│   └── tests
│       ├── cpu_test.sh
│       ├── io_test.sh
│       ├── memory_test.sh
│       └── network_test.sh
└── virtualbox
    └── Vagrantfile
```

## Setup and Installation

Explain how to set up and install your project locally. Provide clear, step-by-step instructions.

**Prerequisites:**

- Vagrant
  
  - [vagrant-libvirt](https://github.com/pradels/vagrant-libvirt)
  
  - [vagrant-scp](https://github.com/invernizzi/vagrant-scp)

- Ansible

- Virsh

- Qemu

- Virtualbox

**Start the cluster:**

```bash
> cd libvirt
> vagrant up --provider=libvirt --no-parallel 
```

**SSH into the vm**

```bash
> vagrant ssh node-00
```

**Halt the VMs**

```bash
> vagrant halt
```

**Destroy the VMs**

```bash
> vagrant destroy
```

## Usage

**Run the test suit**

```bash
vagrant@node-00:~$ cd scripts/
vagrant@node-00:~/scripts/$ ./run_test.sh
```

**Run hpl test**

```bash
vagrant@node-00:~$ cd hpl/bin/linux/
vagrant@node-00:~/hpl/bin/linux/$ mpirun -np 4 ./xhpl 2>&1 | tee -a ~/results/hpl-test.log
```

**Retrieve the results**

```bash
vagrant@node-00:~$ logout
> vagrant scp node-00:/home/vagrant/results ../results/libvirt 
```

## Results

### Libvirt

| Test Type   | Specific Test            | Metric                 | Value       | Units      |
| ----------- | ------------------------ | ---------------------- | ----------- | ---------- |
| **CPU**     | Standard CPU Stress Test | Bogo Ops/s (real time) | 789.64      | bogo ops/s |
|             | Matrix Multiplication    | Bogo Ops/s (real time) | 466.08      | bogo ops/s |
|             | FFT CPU Test             | Bogo Ops/s (real time) | 5000.93     | bogo ops/s |
|             | Phi CPU Test             | Bogo Ops/s (real time) | 97510806.98 | bogo ops/s |
|             | Sysbench CPU Test        | Events per second      | 4978.84     | events/sec |
|             |                          | Latency (avg)          | 0.80        | ms         |
| **HPL**     | HPLinpack Benchmark      | Gflops Rate            | 31.357      | Gflops     |
|             |                          | Time                   | 58.35       | seconds    |
| **Memory**  | VM Stress Test           | Bogo Ops/s (real time) | 71165.18    | bogo ops/s |
|             | Malloc Stress Test       | Bogo Ops/s (real time) | 45187.48    | bogo ops/s |
|             | Bigheap Stress Test      | Bogo Ops/s (real time) | 20920.41    | bogo ops/s |
|             | Sysbench Memory Test     | Transfer Speed         | 74733.10    | MiB/sec    |
|             |                          | Latency (avg)          | 0.08        | ms         |
| **Network** | iperf Bandwidth Test     | Bandwidth              | 12.7        | Gbits/sec  |
|             | ping Latency Test        | RTT (avg)              | 0.615       | ms         |
|             |                          | Packet Loss            | 0           | %          |

**FIO I/O Test (io_test.txt)**

| Metric        | Aggregate Value | Units |
| ------------- | --------------- | ----- |
| Write BW      | 167             | MiB/s |
| Write IOPS    | 21188           | IOPS  |
| Write Latency | -               | -     |

### Virtualbox

Performance Test Summary

| Test Type | Specific Test            | Metric                 | Value       | Units      |
| --------- | ------------------------ | ---------------------- | ----------- | ---------- |
| CPU       | Standard CPU Stress Test | Bogo Ops/s (real time) | 760.82      | bogo ops/s |
|           | Matrix Multiplication    | Bogo Ops/s (real time) | 441.64      | bogo ops/s |
|           | FFT CPU Test             | Bogo Ops/s (real time) | 4549.21     | bogo ops/s |
|           | Phi CPU Test             | Bogo Ops/s (real time) | 87463710.10 | bogo ops/s |
|           | Sysbench CPU Test        | Events per second      | 4540.29     | events/sec |
|           |                          | Latency (avg)          | 0.88        | ms         |
| Memory    | VM Stress Test           | Bogo Ops/s (real time) | 71160.02    | bogo ops/s |
|           | Malloc Stress Test       | Bogo Ops/s (real time) | 33555.54    | bogo ops/s |
|           | Bigheap Stress Test      | Bogo Ops/s (real time) | 16093.94    | bogo ops/s |
|           | Sysbench Memory Test     | Transfer Speed         | 50875.72    | MiB/sec    |
|           |                          | Latency (avg)          | 0.07        | ms         |
| Network   | iperf Bandwidth Test     | Bandwidth              | 3.52        | Gbits/sec  |
|           | ping Latency Test        | RTT (avg)              | 0.343       | ms         |
|           |                          | Packet Loss            | 0           | %          |

FIO I/O Test

| Metric        | Aggregate Value | Units |
| ------------- | --------------- | ----- |
| Write BW      | 94.0            | MiB/s |
| Write IOPS    | 1901-2368       | IOPS  |
| Write Latency | -               | -     |
