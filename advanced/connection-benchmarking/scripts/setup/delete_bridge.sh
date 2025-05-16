#!/bin/bash

echo "Deleting interface br-veth0..."
sudo ip link delete br-veth0
echo "Interface br-veth0 deleted."

echo "Deleting interface br-veth1..."
sudo ip link delete br-veth1
echo "Interface br-veth1 deleted."

echo "Deleting interface br0..."
sudo ip link delete br0
echo "Interface br0 deleted."