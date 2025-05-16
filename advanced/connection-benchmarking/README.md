# Network Interfaces Benchmark

## Description

This project explores various methods for connecting two Linux network namespaces (`ns1` and `ns2`) and testing the network performance between them. The following connection methods are implemented and tested:

1. **Direct veth pair:** A single `veth` pair connects `ns1` directly to `ns2`.
2. **veth pairs connected to a single bridge:** Each namespace has a `veth` pair, and both pairs are connected to a single Linux bridge (`br0`).
3. **veth pairs on separate bridges connected via VXLAN:** Each namespace has a `veth` pair connected to its own bridge (`br0` for `ns1`, `br1` for `ns2`). These two bridges are then connected via a VXLAN tunnel.

The setup process involves creating the network namespaces, configuring the chosen connection method, assigning IP addresses, and ensuring network connectivity between `ns1` and `ns2`.

The scripts for setting up and tearing down these configurations are located in the `benchmark/setup` directory.

Network performance is measured between `ns1` and `ns2` for each connection method using `iperf`. The key metrics collected are:

* **Bandwidth:** Measured using `iperf` in throughput mode.
* **Latency:** Measured using `iperf` in latency or ping mode (details depend on the specific `iperf` usage in `tests/latency_test.sh`).

The test scripts are located in the `benchmark/tests` directory. The main test execution script is `benchmark/run_test.sh`, which orchestrates the setup, testing, and teardown for each configuration.

## Project Structure

```bash
.
├── assignment.md
├── README.md
├── results
│   ├── bridge_bandwidth.txt
│   ├── bridge_latency.txt
│   ├── veth_bandwidth.txt
│   ├── veth_latency.txt
│   ├── vxlan_bandwidth.txt
│   └── vxlan_latency.txt
├── scripts
│   ├── run_test.sh
│   ├── setup
│   │   ├── create_namespaces.sh
│   │   ├── delete_bridge.sh
│   │   ├── delete_namespaces.sh
│   │   ├── delete_veth.sh
│   │   ├── delete_vxlan.sh
│   │   ├── setup_bridge.sh
│   │   ├── setup_veth.sh
│   │   └── setup_vxlan.sh
│   └── tests
│       ├── bandwidth_test.sh
│       └── latency_test.sh
└── Vagrantfile
```

## Setup and Installation

**Prerequisites:**

- Vagrant
  
  - [vagrant-libvirt](https://github.com/pradels/vagrant-libvirt)
  
  - [vagrant-scp](https://github.com/invernizzi/vagrant-scp)

- Virsh

**Spin up the VM**

```bash
> vagrant up
```

**Halt the VM**

```bash
> vagrant halt
```

**Destroy the VM**

```bash
> vagrant destroy
```

## Usage

**Access the VM and execute the tests:**

```bash
> vagrant ssh vm
vagrant@vm:~$ cd scripts
vagrant@vm:~/scripts$ ./run_test.sh
```

The `run_test.sh` script will execute the setup, testing, and teardown for each connection method. This process will take some time to complete.

**Exit the VM:**

```bash
vagrant@vm:~$ logout
```

**Retrieve the results:**

```bash
> vagrant scp vm:/home/vagrant/results .
```

This command will copy the `results` directory from the VM to your local machine.

## Results

| Test Type | Bandwidth      | Latency (avg rtt) |
| --------- | -------------- |:-----------------:|
| Bridge    | 45.0 Gbits/sec | 0.069 ms          |
| VETH      | 49.9 Gbits/sec | 0.066 ms          |
| VXLAN     | 42.3 Gbits/sec | 0.080 ms          |
