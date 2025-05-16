#!/bin/bash

echo "Creating bridges..."
ip link add br0 type bridge
ip link add br1 type bridge
ip link set br0 up
ip link set br1 up
echo "Bridges created and activated."

echo "Creating and configuring veth pairs for ns1..."
ip link add veth0 type veth peer name veth0-br
ip link set veth0-br up
ip link set veth0-br master br0
ip link set veth0 netns ns1
ip netns exec ns1 ip link set veth0 up
ip netns exec ns1 ip addr add 10.1.1.2/24 dev veth0
echo "ns1 veth pair configured."

echo "Creating and configuring veth pairs for ns2..."
ip link add veth1 type veth peer name veth1-br
ip link set veth1-br up
ip link set veth1-br master br1
ip link set veth1 netns ns2
ip netns exec ns2 ip link set veth1 up
ip netns exec ns2 ip addr add 10.1.2.2/24 dev veth1
echo "ns2 veth pair configured."

echo "Setting up VXLAN tunnel between bridges..."
ip link add vxlan0 type vxlan id 100 local 127.0.0.1 remote 127.0.0.1 dstport 4789 dev lo
ip link add vxlan1 type vxlan id 101 local 127.0.0.1 remote 127.0.0.1 dstport 4790 dev lo
ip link set vxlan0 master br0
ip link set vxlan1 master br1
ip link set vxlan0 up
ip link set vxlan1 up
echo "VXLAN tunnel established."

echo "Configuring IP addresses and routing..."
ip addr add 10.1.1.1/24 dev br0
ip addr add 10.1.2.1/24 dev br1
ip netns exec ns1 ip route add 10.1.2.0/24 via 10.1.1.1
ip netns exec ns2 ip route add 10.1.1.0/24 via 10.1.2.1
echo "IP addressing and routing configured."

echo "Enabling IP forwarding..."
sysctl -w net.ipv4.ip_forward=1
echo "IP forwarding enabled."


echo "Network setup with VXLAN completed successfully!"