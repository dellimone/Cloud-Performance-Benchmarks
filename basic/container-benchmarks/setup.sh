#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Define ANSI Color Codes
COLOR_RESET='\e[0m'
COLOR_HEADER='\e[1;34m' # Bold Blue for main headers
COLOR_SECTION='\e[1;36m' # Bold Cyan for section headers
COLOR_SETUP='\e[32m'    # Green for setup steps
COLOR_TEST='\e[34m'     # Blue for test steps/output (used for build output here)
COLOR_CLEANUP='\e[33m'  # Yellow for cleanup steps
COLOR_STATUS='\e[32m'   # Green for successful status messages
COLOR_ERROR='\e[31m'    # Red for errors (though set -e exits)

# Define Docker image names
HPL_IMAGE="hpl-test"
BASE_IMAGE="base-test"
IPERF_SERVER_IMAGE="iperf-server"

# --- Main Script Execution ---

echo -e "${COLOR_HEADER}===== STARTING DOCKER IMAGE BUILD PROCESS =====${COLOR_RESET}"

# --- Build hpl-test image ---
echo -e "\n${COLOR_SECTION}===== BUILDING: ${HPL_IMAGE} =====${COLOR_RESET}"
echo -e "${COLOR_SETUP}[SETUP] Preparing to build ${HPL_IMAGE}...${COLOR_RESET}"
echo -e "${COLOR_TEST}[BUILD] Running docker build for ${HPL_IMAGE}...${COLOR_RESET}"
docker build -t "$HPL_IMAGE" -f docker/hpl-test/Dockerfile .
echo -e "${COLOR_STATUS}[BUILD] Successfully built ${HPL_IMAGE}.${COLOR_RESET}"

# --- Build base-test image ---
echo -e "\n${COLOR_SECTION}===== BUILDING: ${BASE_IMAGE} =====${COLOR_RESET}"
echo -e "${COLOR_SETUP}[SETUP] Preparing to build ${BASE_IMAGE}...${COLOR_RESET}"
echo -e "${COLOR_TEST}[BUILD] Running docker build for ${BASE_IMAGE}...${COLOR_RESET}"
docker build -t "$BASE_IMAGE" -f docker/base-test/Dockerfile .
echo -e "${COLOR_STATUS}[BUILD] Successfully built ${BASE_IMAGE}.${COLOR_RESET}"

# --- Build iperf-server image ---
echo -e "\n${COLOR_SECTION}===== BUILDING: ${IPERF_SERVER_IMAGE} =====${COLOR_RESET}"
echo -e "${COLOR_SETUP}[SETUP] Preparing to build ${IPERF_SERVER_IMAGE}...${COLOR_RESET}"
echo -e "${COLOR_TEST}[BUILD] Running docker build for ${IPERF_SERVER_IMAGE}...${COLOR_RESET}"
docker build -t "$IPERF_SERVER_IMAGE" -f docker/iperf-server/Dockerfile .
echo -e "${COLOR_STATUS}[BUILD] Successfully built ${IPERF_SERVER_IMAGE}.${COLOR_RESET}"

echo -e "\n${COLOR_HEADER}===== DOCKER IMAGE BUILD PROCESS COMPLETE =====${COLOR_RESET}"
echo -e "${COLOR_STATUS}All specified Docker images have been built.${COLOR_RESET}"