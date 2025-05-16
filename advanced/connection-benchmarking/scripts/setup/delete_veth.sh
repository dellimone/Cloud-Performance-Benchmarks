#!/bin/bash

echo "Starting network namespace interface deletion..."

echo "Deleting interface veth0 in namespace ns1..."
sudo ip netns exec ns1 ip link delete veth0
echo "Interface veth0 deleted in ns1."


# sudo ip netns exec ns2 ip link delete veth1

