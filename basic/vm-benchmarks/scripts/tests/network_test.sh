#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Output file
OUTPUT_FILE="$1"
TARGET_IP="$2"  # Pass target IP as an argument

if [ -z "$TARGET_IP" ]; then
    echo "Error: TARGET_IP not specified" | tee -a ${OUTPUT_FILE}
    exit 1
fi

echo -e "--- iperf bandwidth test ---" | tee -a ${OUTPUT_FILE}
iperf --client "$TARGET_IP" --time 30 2>&1 | tee -a ${OUTPUT_FILE}

echo -e "\n--- ping latency test ---" | tee -a ${OUTPUT_FILE}
COUNT=50 # Number of pings
ping -c "$COUNT" -i 0.2 "$TARGET_IP" 2>&1 | tee -a ${OUTPUT_FILE}