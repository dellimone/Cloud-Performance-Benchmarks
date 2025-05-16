#!/bin/bash

echo "Starting network setup script..."

echo "Creating bridge br0..."
# Create bridge
ip link add br0 type bridge
echo "Bridge br0 created."

echo "Bringing up bridge br0..."
ip link set br0 up
echo "Bridge br0 is up."

echo "Creating veth pairs veth0/br-veth0 and veth1/br-veth1..."
# Create veth pairs
ip link add veth0 type veth peer name br-veth0
ip link add veth1 type veth peer name br-veth1
echo "Veth pairs created."

echo "Connecting veth pairs to namespaces (ns1, ns2) and bridge (br0)..."
# Connect veth pairs to namespaces and bridge
ip link set veth0 netns ns1
ip link set veth1 netns ns2
ip link set br-veth0 master br0
ip link set br-veth1 master br0
echo "Veth pairs connected."

echo "Bringing up bridge-side veth interfaces (br-veth0, br-veth1)..."
ip link set br-veth0 up
ip link set br-veth1 up
echo "Bridge-side veth interfaces are up."

echo "Configuring IP addresses for namespace-side veth interfaces..."
# Configure IP addresses
ip netns exec ns1 ip addr add 10.0.2.1/24 dev veth0
ip netns exec ns2 ip addr add 10.0.2.2/24 dev veth1
echo "IP addresses configured."

echo "Bringing up namespace-side veth interfaces (veth0 in ns1, veth1 in ns2)..."
# Bring up interfaces
ip netns exec ns1 ip link set veth0 up
ip netns exec ns2 ip link set veth1 up
echo "Namespace-side veth interfaces are up."

echo "Network setup script completed successfully!"
