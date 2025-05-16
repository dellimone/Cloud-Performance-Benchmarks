#!/bin/bash

echo "Creating veth pair veth0/veth1..."
# Direct veth pair connection
ip link add veth0 type veth peer name veth1
echo "Veth pair created."

echo "Assigning veth interfaces to namespaces (veth0 to ns1, veth1 to ns2)..."
ip link set veth0 netns ns1
ip link set veth1 netns ns2
echo "Veth interfaces assigned to namespaces."

echo "Configuring IP addresses for namespace interfaces..."
# Configure IP addresses
ip netns exec ns1 ip addr add 10.0.1.1/24 dev veth0
ip netns exec ns2 ip addr add 10.0.1.2/24 dev veth1
echo "IP addresses configured."

echo "Bringing up interfaces in namespaces (veth0 in ns1, veth1 and lo in ns2)..."
# Bring up interfaces
ip netns exec ns1 ip link set veth0 up
ip netns exec ns1 ip link set lo up # Bringing up loopback in ns1
ip netns exec ns2 ip link set veth1 up
ip netns exec ns2 ip link set lo up # Bringing up loopback in ns2
echo "Interfaces are up in namespaces."