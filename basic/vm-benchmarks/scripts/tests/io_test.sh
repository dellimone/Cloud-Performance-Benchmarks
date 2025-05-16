#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Output file
OUTPUT_FILE="$1"

echo -e "--- IOZone local filesystem test ---" | tee -a ${OUTPUT_FILE}
iozone -a 2>&1 | tee -a ${OUTPUT_FILE}

echo -e "\n--- FIO local I/O test ---" | tee -a ${OUTPUT_FILE}
fio --name=mytest --ioengine=libaio --rw=randwrite --bs=4k --numjobs=16 \
    --size=1G --runtime=10s --time_based --unlink=1 2>&1 | tee -a ${OUTPUT_FILE}


cd /mnt/nfs_server_share

echo -e "--- IOZone shared filesystem test ---" | tee -a ${OUTPUT_FILE}
iozone -a 2>&1 | tee -a ${OUTPUT_FILE}

echo -e "\n--- FIO shared I/O test ---" | tee -a ${OUTPUT_FILE}
fio --name=mytest --ioengine=libaio --rw=randwrite --bs=4k --numjobs=16 \
    --size=1G --runtime=10s --time_based --unlink=1 2>&1 | tee -a ${OUTPUT_FILE}

