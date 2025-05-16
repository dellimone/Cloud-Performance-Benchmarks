#!/bin/bash

# Delete network namespaces
echo "Deleting network namespace ns1..."
ip netns delete ns1
echo "Network namespace ns1 deleted."

echo "Deleting network namespace ns2..."
ip netns delete ns2
echo "Network namespace ns2 deleted."