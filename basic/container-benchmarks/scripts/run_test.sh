#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Define ANSI Color Codes
COLOR_RESET='\e[0m'
COLOR_HEADER='\e[1;34m' # Bold Blue for main headers
COLOR_SECTION='\e[1;36m' # Bold Cyan for section headers
COLOR_SETUP='\e[32m'    # Green for setup steps
COLOR_TEST='\e[34m'     # Blue for test steps/output
COLOR_CLEANUP='\e[33m'  # Yellow for cleanup steps
COLOR_STATUS='\e[32m'   # Green for successful status messages
COLOR_ERROR='\e[31m'    # Red for errors (though set -e exits)

# Define paths to scripts
TEST_DIR="./tests"
RESULTS_DIR="../results"

# Ensure scripts are executable
chmod +x ${TEST_DIR}/*.sh

# Ensure results directory exists
mkdir -p "$RESULTS_DIR"

echo -e "${COLOR_HEADER}===== STARTING SYSTEM PERFORMANCE TEST SUITE =====${COLOR_RESET}"
echo -e "${COLOR_STATUS}Tests will output to both terminal and log files${COLOR_RESET}"

# --- CPU Test ---
echo -e "\n${COLOR_SECTION}===== TESTING: CPU Performance =====${COLOR_RESET}"
echo -e "${COLOR_SETUP}[SETUP] Preparing CPU test...${COLOR_RESET}"
CPU_OUTPUT="${RESULTS_DIR}/cpu_test.log"
# Clear the output file before starting
> ${CPU_OUTPUT}
echo -e "${COLOR_TEST}[TEST] Running CPU tests...${COLOR_RESET}"
${TEST_DIR}/cpu_test.sh ${CPU_OUTPUT}
echo -e "${COLOR_STATUS}[TEST] CPU tests complete. Results saved to ${CPU_OUTPUT}${COLOR_RESET}"

# --- HPL Test ---
echo -e "\n${COLOR_SECTION}===== TESTING: HPL Performance =====${COLOR_RESET}"
echo -e "${COLOR_SETUP}[SETUP] Preparing HPL test...${COLOR_RESET}"
HPL_OUTPUT="${RESULTS_DIR}/hpl_test.log"
# Clear the output file before starting

# --- Memory Test ---
echo -e "\n${COLOR_SECTION}===== TESTING: Memory Performance =====${COLOR_RESET}"
echo -e "${COLOR_SETUP}[SETUP] Preparing Memory test...${COLOR_RESET}"
MEMORY_OUTPUT="${RESULTS_DIR}/memory_test.log"
# Clear the output file before starting
> ${MEMORY_OUTPUT}
echo -e "${COLOR_TEST}[TEST] Running Memory tests...${COLOR_RESET}"
${TEST_DIR}/memory_test.sh ${MEMORY_OUTPUT}
echo -e "${COLOR_STATUS}[TEST] Memory tests complete. Results saved to ${MEMORY_OUTPUT}${COLOR_RESET}"

# --- IO Test ---
echo -e "\n${COLOR_SECTION}===== TESTING: I/O Performance =====${COLOR_RESET}"
echo -e "${COLOR_SETUP}[SETUP] Preparing I/O test...${COLOR_RESET}"
IO_OUTPUT="${RESULTS_DIR}/io_test.log"
# Clear the output file before starting
> ${IO_OUTPUT}
echo -e "${COLOR_TEST}[TEST] Running I/O tests...${COLOR_RESET}"
${TEST_DIR}/io_test.sh ${IO_OUTPUT}
echo -e "${COLOR_STATUS}[TEST] I/O tests complete. Results saved to ${IO_OUTPUT}${COLOR_RESET}"

# --- Network Test ---
echo -e "\n${COLOR_SECTION}===== TESTING: Network Performance =====${COLOR_RESET}"
echo -e "${COLOR_SETUP}[SETUP] Preparing Network test...${COLOR_RESET}"
NETWORK_OUTPUT="${RESULTS_DIR}/network_test.log"
# Clear the output file before starting
> ${NETWORK_OUTPUT}

echo -e "\n${COLOR_HEADER}===== SYSTEM PERFORMANCE TEST SUITE COMPLETE =====${COLOR_RESET}"
echo -e "${COLOR_STATUS}All results saved in ${RESULTS_DIR}${COLOR_RESET}"