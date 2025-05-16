#!/bin/bash

# Expect target IP as the first argument
TARGET_IP=$1

if [ -z "$TARGET_IP" ]; then
  echo "Usage: $0 <target_ip> [test_type]"
  exit 1
fi

echo "Running iperf bandwidth test from ns1 to $TARGET_IP..."

# Start iperf server in ns2 (backgrounded and quiet unless error)
echo "Starting iperf server in ns2..."
sudo ip netns exec ns2 iperf --server --daemon > /dev/null 2>&1
# Check if server started 
sleep 2 # Give server time to start
if ! sudo ip netns exec ns2 pgrep iperf > /dev/null; then
    echo "ERROR: Failed to start iperf server in ns2."
    exit 1
fi

# Run iperf client in ns1
echo "Starting iperf client in ns1..."
sudo ip netns exec ns1 iperf --client "$TARGET_IP" --time 30 # --reportstyle C # CSV output might be easier to parse

# Stop iperf server
echo "Stopping iperf server in ns2..."
sudo ip netns exec ns2 pkill iperf

echo "Bandwidth test complete."