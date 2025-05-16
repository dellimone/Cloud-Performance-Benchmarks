#!/bin/bash

# Expect target IP as the first argument
TARGET_IP=$1

if [ -z "$TARGET_IP" ]; then
  echo "Usage: $0 <target_ip> [test_type]"
  exit 1
fi

COUNT=50 # Number of pings

echo "Running ping latency test from ns1 to $TARGET_IP (${COUNT} packets)..."

# Run ping from ns1 to target IP in ns2
sudo ip netns exec ns1 ping -c "$COUNT" -i 0.2 "$TARGET_IP" 

echo "Latency test complete."