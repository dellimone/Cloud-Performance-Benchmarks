#!/bin/bash

# Create network namespaces
echo "Creating network namespace ns1..."
sudo ip netns add ns1
echo "Network namespace ns1 created."

echo "Creating network namespace ns2..."
sudo ip netns add ns2
echo "Network namespace ns2 created."