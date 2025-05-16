#!/bin/bash

# Delete VXLAN interfaces
echo "Deleting VXLAN interface vxlan0..."
sudo ip link delete vxlan0
echo "VXLAN interface vxlan0 deleted."

echo "Deleting VXLAN interface vxlan1..."
sudo ip link delete vxlan1
echo "VXLAN interface vxlan1 deleted."

# Delete bridges
echo "Deleting bridge br0..."
sudo ip link delete br0
echo "Bridge br0 deleted."

echo "Deleting bridge br1..."
sudo ip link delete br1
echo "Bridge br1 deleted."

# Delete veth peer interfaces on the host (those not in namespaces)
echo "Deleting host-side veth interface veth0-br..."
sudo ip link delete veth0-br
echo "Host-side veth interface veth0-br deleted."

echo "Deleting host-side veth interface veth1-br..."
sudo ip link delete veth1-br
echo "Host-side veth interface veth1-br deleted."

# Delete veth interfaces inside the namespaces (optional: removed with namespaces)
#sudo ip netns exec ns1 ip link delete veth0
#sudo ip netns exec ns2 ip link delete veth1

# Optionally, disable IP forwarding again
#sudo sysctl -w net.ipv4.ip_forward=0
