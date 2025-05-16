#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Output file
OUTPUT_FILE="$1"

echo -e "--- VM stress test ---" | tee -a ${OUTPUT_FILE}
stress-ng --vm 4 --vm-bytes 1G --timeout 60s --metrics-brief 2>&1 | tee -a ${OUTPUT_FILE}

echo -e "\n--- Malloc stress test ---" | tee -a ${OUTPUT_FILE}
stress-ng --malloc 4 --malloc-bytes 1G --timeout 60s --metrics-brief 2>&1 | tee -a ${OUTPUT_FILE}

echo -e "\n--- Bigheap stress test ---" | tee -a ${OUTPUT_FILE}
stress-ng --bigheap 2 --timeout 60s --metrics-brief 2>&1 | tee -a ${OUTPUT_FILE}

echo -e "\n--- Sysbench memory test ---" | tee -a ${OUTPUT_FILE}
sysbench memory --memory-block-size=1M --memory-total-size=10G --threads=4 run 2>&1 | tee -a ${OUTPUT_FILE}