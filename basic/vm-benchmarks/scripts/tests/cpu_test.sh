#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Output file
OUTPUT_FILE="$1"
NUM_CPU_WORKERS=4
TEST_DURATION=60

echo -e "--- Standard CPU stress test ---" | tee -a ${OUTPUT_FILE}
stress-ng --cpu ${NUM_CPU_WORKERS} --timeout ${TEST_DURATION}s --metrics-brief 2>&1 | tee -a ${OUTPUT_FILE}

echo -e "\n--- Matrix multiplication CPU test ---" | tee -a ${OUTPUT_FILE}
stress-ng --cpu ${NUM_CPU_WORKERS} --cpu-method matrixprod --timeout ${TEST_DURATION}s --metrics-brief 2>&1 | tee -a ${OUTPUT_FILE}

echo -e "\n--- FFT CPU test ---" | tee -a ${OUTPUT_FILE}
stress-ng --cpu ${NUM_CPU_WORKERS} --cpu-method fft --timeout ${TEST_DURATION}s --metrics-brief 2>&1 | tee -a ${OUTPUT_FILE}

echo -e "\n--- Phi CPU test ---" | tee -a ${OUTPUT_FILE}
stress-ng --cpu ${NUM_CPU_WORKERS} --cpu-method phi --timeout ${TEST_DURATION}s --metrics-brief 2>&1 | tee -a ${OUTPUT_FILE}

echo -e "\n--- Sysbench CPU test ---" | tee -a ${OUTPUT_FILE}
sysbench cpu --cpu-max-prime=20000 --threads=4 --time=${TEST_DURATION} run 2>&1 | tee -a ${OUTPUT_FILE}