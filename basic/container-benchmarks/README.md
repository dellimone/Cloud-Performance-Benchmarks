# Containers benchmark

## Description

This project provides a self-contained, Dockerized environment for conducting a range of system performance benchmarks. It leverages `docker-compose` to define and orchestrate the necessary services (containers) and their network, offering a consistent and portable way to measure the performance characteristics of different environments or configurations without direct installation of benchmark tools on the host system.

The benchmarking environment, as defined by the `docker-compose.yml` file, consists of the following services:

* **iperf-server:** This container is configured specifically to run the `iperf` network benchmarking tool in server mode. Its primary role is to act as the endpoint for network performance tests initiated from other containers, allowing for measurement of network bandwidth between services within the defined Docker network.
* **base-test:** This is the primary worker container for general system benchmarks. Its Dockerfile includes the installation of a comprehensive suite of benchmarking tools, including `stress-ng` (for CPU and memory stress), `sysbench` (for CPU and memory performance), `iozone3` and potentially `fio` (for disk I/O), and `iperf` and `iputils-ping` (for network testing). This container is where the core benchmark scripts (`cpu_test.sh`, `memory_test.sh`, `io_test.sh`, `network_test.sh`) are executed.
* **hpl-test:** This container is intended for running the High-Performance LINPACK (HPL) benchmark, a standard for rating the floating-point performance of computer systems. Its Dockerfile would include the necessary dependencies and the HPL benchmark itself. This service is designed for assessing heavy floating-point computation capabilities.

All containers operate within a dedicated `bm-network` (bridge driver) defined by Docker Compose, facilitating communication between services (e.g., the `base-test` container connecting to the `iperf-server`). A shared volume maps the `./results` directory on the host machine to `/benchmark/results` inside the containers, ensuring that all benchmark output is easily accessible and persisted outside the containers.

The provisioned environment is equipped to perform a suite of performance benchmarks using the scripts located in the `scripts/` directory (which are copied into the containers). These tests are designed to evaluate key performance aspects of the system the containers are running on:

* **CPU Performance:** These tests measure the processing capabilities using tools like `stress-ng` with various methods (standard stress, matrix multiplication, FFT, Phi) to apply different types of computational load, and `sysbench` for a general CPU performance evaluation.
* **Memory Performance:** This category assesses the memory subsystem's speed and capacity. `stress-ng` is used for various memory stress tests (VM, malloc, bigheap), and `sysbench` provides dedicated memory read/write tests.
* **I/O Performance:** Focusing on storage performance, these tests evaluate how efficiently the system can handle disk read and write operations. `iozone3` is used for filesystem-level testing, and `fio` provides capabilities for more granular block-level I/O testing (e.g., random writes as seen in the script). The performance observed here will reflect the performance of the underlying storage available to the Docker containers.
* **Network Performance:** Essential for understanding the interconnectivity, these tests measure network bandwidth using `iperf` between the `base-test` client and the `iperf-server`, and network latency using `ping`.
* **HPC Performance (HPL):** The `hpl-test` container is specifically set up to run the HPL benchmark, providing a measure of the system's high-performance floating-point computing capability.

## Project Structure

```
.
├── assignment.md
├── docker
│   ├── base-test
│   │   └── Dockerfile
│   ├── hpl-test
│   │   ├── Dockerfile
│   │   └── HPL.dat
│   └── iperf-server
│       └── Dockerfile
├── docker-compose.yml
├── README.md
├── results
├── scripts
│   ├── run_test.sh
│   └── tests
│       ├── cpu_test.sh
│       ├── io_test.sh
│       ├── memory_test.sh
│       └── network_test.sh
└── setup.sh
```

## Setup and Installation

**Prerequisites:**

* Docker

**Building docker images:**

```bash
> ./setup.sh
```

**Run the containers**

```bash
> docker compose up -d
```

**Stop the containers**

```bash
> docker compose down
```

**Remove images**

```bash
> docker rmi iperf-server hpl-test base-test
```

## Usage

```bash
> docker exec -it hpl-test bash
root@<containerid>:/opt/hpl/bin/linux> mpirun --allow-run-as-root -np 4 ./xhpl 2>&1 | tee -a /benchmark/results/hpl-test.log
root@<containerid>:/opt/hpl/bin/linux> logout
```

```bash
> docker exec -it base-test bash
root@9ea4555ef292:/benchmark> cd scripts/
root@9ea4555ef292:/benchmark> ./run_tests.sh
root@9ea4555ef292:/benchmark> logout
```

The results are stored in `results`

## Results

**Performance Test Summary**

| Test Type   | Specific Test            | Metric                 | Value       | Units      |
| ----------- | ------------------------ | ---------------------- | ----------- | ---------- |
| **CPU**     | Standard CPU Stress Test | Bogo Ops/s (real time) | 1310.85     | bogo ops/s |
|             | Matrix Multiplication    | Bogo Ops/s (real time) | 484.22      | bogo ops/s |
|             | FFT CPU Test             | Bogo Ops/s (real time) | 5030.55     | bogo ops/s |
|             | Phi CPU Test             | Bogo Ops/s (real time) | 96900008.20 | bogo ops/s |
|             | Sysbench CPU Test        | Events per second      | 4978.84     | events/sec |
|             |                          | Latency (avg)          | 0.80        | ms         |
| **HPL**     | HPLinpack Benchmark      | Gflops Rate            | 14.413      | Gflops     |
|             |                          | Time                   | 126.94      | seconds    |
| **Memory**  | VM Stress Test           | Bogo Ops/s (real time) | 71141.38    | bogo ops/s |
|             | Malloc Stress Test       | Bogo Ops/s (real time) | 42760.82    | bogo ops/s |
|             | Bigheap Stress Test      | Bogo Ops/s (real time) | 6876.28     | bogo ops/s |
|             | Sysbench Memory Test     | Transfer Speed         | 60014.39    | MiB/sec    |
|             |                          | Latency (avg)          | 0.07        | ms         |
| **Network** | iperf Bandwidth Test     | Bandwidth              | 27.6        | Gbits/sec  |
|             | ping Latency Test        | RTT (avg)              | 0.115       | ms         |
|             |                          | Packet Loss            | 0           | %          |

**FIO I/O Test (io_test.txt)**

| Metric        | Aggregate Value | Units |
| ------------- | --------------- | ----- |
| Write BW      | 338             | MiB/s |
| Write IOPS    | ~21188          | IOPS  |
| Write Latency | -               | -     |

*Note: The IOZone test provides a large table of data in the original file and is not included here in full.*
