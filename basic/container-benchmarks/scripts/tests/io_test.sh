#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Output file
OUTPUT_FILE="$1"

echo -e "--- IOZone filesystem test ---" | tee -a ${OUTPUT_FILE}
iozone -a 2>&1 | tee -a ${OUTPUT_FILE}

echo -e "\n--- FIO I/O test ---" | tee -a ${OUTPUT_FILE}
fio --name=mytest --ioengine=libaio --rw=randwrite --bs=4k --numjobs=16 \
    --size=1G --runtime=10s --time_based --unlink=1 2>&1 | tee -a ${OUTPUT_FILE}