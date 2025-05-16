# Network Performance Testing with Linux Network Namespaces

**Objective**: Evaluate and compare the network performance of different inter-

namespace connection methods using Linux network namespaces.
**Setup**:

1. Create two network namespaces, ns1 and ns2, on a Linux system.
2. Connect ns1 and ns2 using the following methods:
   • Directly via a veth pair (e.g., veth0 in ns1 connected to veth1 in
   ns2)
   • One veth pair per namespace, with both veth pairs connected to a
   bridge (e.g., br0)
   • Two veth pairs (one per namespace), each connected to a separate
   bridge (e.g., br0 and br1), which are then connected via VXLAN
3. Configure IP addresses for each namespace and ensure connectivity between
   them.

**Performance Testing**:

1. Run iperf tests to measure bandwidth and latency between ns1 and ns2 for each connection method.

2. Record the results, including throughput and latency.

3. Compare the performance metrics across the different connection methods.

Comparison with Cloud Basic Case:

1. Record the results, including throughput and latency.

2. Compare the performance metrics between the cloud basic case and the
   network namespace setup.

3. 3. Comment on any differences or similarities observed.

**Deliverables**: A detailed report containing:

- Steps for setting up network namespaces and connecting them using different methods

- iperf test results, including throughput and latency, for each connection method

- Comparison of performance metrics across connection methods and with the cloud basic case

- Discussion on the implications of the results
