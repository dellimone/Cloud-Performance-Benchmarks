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
SETUP_DIR="./setup"
TEST_DIR="./tests"
RESULTS_DIR="../results" # Assuming raw results go here

# Ensure results directory exists
mkdir -p "$RESULTS_DIR"

echo -e "${COLOR_HEADER}===== STARTING NETWORK PERFORMANCE TEST RUN =====${COLOR_RESET}"

# 1. Create namespaces
echo -e "${COLOR_SETUP}[SETUP] Creating namespaces...${COLOR_RESET}"
sudo "$SETUP_DIR/create_namespaces.sh" # This script uses ip netns, might need sudo depending on user permissions
echo -e "${COLOR_STATUS}[SETUP] Namespaces created.${COLOR_RESET}"

# --- VETH Test ---
echo -e "\n${COLOR_SECTION}===== TESTING: Direct VETH Connection =====${COLOR_RESET}"
# 2. Setup veth
echo -e "${COLOR_SETUP}[SETUP] Configuring VETH...${COLOR_RESET}"
sudo "$SETUP_DIR/setup_veth.sh" # Sets up 10.0.1.1 (ns1) and 10.0.1.2 (ns2)
VETH_TARGET_IP="10.0.1.2"
echo -e "${COLOR_STATUS}[SETUP] VETH configured.${COLOR_RESET}"

# 3. Execute tests (Veth)
echo -e "${COLOR_TEST}[TEST] Running tests for VETH...${COLOR_RESET}"
echo -e "${COLOR_TEST}--- Bandwidth Test (VETH) ---${COLOR_RESET}" | tee -a "$RESULTS_DIR/veth_bandwidth.txt"
sudo "$TEST_DIR/bandwidth_test.sh" "$VETH_TARGET_IP" | tee -a "$RESULTS_DIR/veth_bandwidth.txt"
echo -e "${COLOR_TEST}--- Latency Test (VETH) ---${COLOR_RESET}" | tee -a "$RESULTS_DIR/veth_latency.txt"
sudo "$TEST_DIR/latency_test.sh" "$VETH_TARGET_IP" | tee -a "$RESULTS_DIR/veth_latency.txt"
echo -e "${COLOR_STATUS}[TEST] VETH tests complete.${COLOR_RESET}"

# 4. Delete veth
echo -e "${COLOR_CLEANUP}[CLEANUP] Deleting VETH...${COLOR_RESET}"
sudo "$SETUP_DIR/delete_veth.sh"
echo -e "${COLOR_STATUS}[CLEANUP] VETH deleted.${COLOR_RESET}"

# --- Bridge Test ---
echo -e "\n${COLOR_SECTION}===== TESTING: Bridge Connection =====${COLOR_RESET}"
# 5. Setup bridge
echo -e "${COLOR_SETUP}[SETUP] Configuring Bridge...${COLOR_RESET}"
sudo "$SETUP_DIR/setup_bridge.sh" # Sets up 10.0.2.1 (ns1) and 10.0.2.2 (ns2)
BRIDGE_TARGET_IP="10.0.2.2"
echo -e "${COLOR_STATUS}[SETUP] Bridge configured.${COLOR_RESET}"

# 6. Execute tests (Bridge)
echo -e "${COLOR_TEST}[TEST] Running tests for Bridge...${COLOR_RESET}"
echo -e "${COLOR_TEST}--- Bandwidth Test (Bridge) ---${COLOR_RESET}" | tee -a "$RESULTS_DIR/bridge_bandwidth.txt"
sudo "$TEST_DIR/bandwidth_test.sh" "$BRIDGE_TARGET_IP" | tee -a "$RESULTS_DIR/bridge_bandwidth.txt"
echo -e "${COLOR_TEST}--- Latency Test (Bridge) ---${COLOR_RESET}" | tee -a "$RESULTS_DIR/bridge_latency.txt"
sudo "$TEST_DIR/latency_test.sh" "$BRIDGE_TARGET_IP" | tee -a "$RESULTS_DIR/bridge_latency.txt"
echo -e "${COLOR_STATUS}[TEST] Bridge tests complete.${COLOR_RESET}"

# 7. Delete bridge
echo -e "${COLOR_CLEANUP}[CLEANUP] Deleting Bridge...${COLOR_RESET}"
sudo "$SETUP_DIR/delete_bridge.sh"
# Note: delete_bridge.sh might not remove the veth pairs inside the namespaces.
# We rely on delete_namespaces.sh for final cleanup, or add specific deletion here if needed.
# For thoroughness, let's try deleting the veths specifically if they exist.
sudo ip netns exec ns1 ip link delete veth0 > /dev/null 2>&1 || true
sudo ip netns exec ns2 ip link delete veth1 > /dev/null 2>&1 || true
echo -e "${COLOR_STATUS}[CLEANUP] Bridge deleted.${COLOR_RESET}"


# --- VXLAN Test ---
echo -e "\n${COLOR_SECTION}===== TESTING: VXLAN Connection =====${COLOR_RESET}"
# 8. Setup vxlan
echo -e "${COLOR_SETUP}[SETUP] Configuring VXLAN...${COLOR_RESET}"
sudo "$SETUP_DIR/setup_vxlan.sh" # Sets up 10.1.1.2 (ns1) and 10.1.2.2 (ns2)
VXLAN_TARGET_IP="10.1.2.2" # Target IP is in ns2
echo -e "${COLOR_STATUS}[SETUP] VXLAN configured.${COLOR_RESET}"

# 9. Execute tests (VXLAN)
echo -e "${COLOR_TEST}[TEST] Running tests for VXLAN...${COLOR_RESET}"
echo -e "${COLOR_TEST}--- Bandwidth Test (VXLAN) ---${COLOR_RESET}" | tee -a "$RESULTS_DIR/vxlan_bandwidth.txt"
sudo "$TEST_DIR/bandwidth_test.sh" "$VXLAN_TARGET_IP" | tee -a "$RESULTS_DIR/vxlan_bandwidth.txt"
echo -e "${COLOR_TEST}--- Latency Test (VXLAN) ---${COLOR_RESET}" | tee -a "$RESULTS_DIR/vxlan_latency.txt"
sudo "$TEST_DIR/latency_test.sh" "$VXLAN_TARGET_IP" | tee -a "$RESULTS_DIR/vxlan_latency.txt"
echo -e "${COLOR_STATUS}[TEST] VXLAN tests complete.${COLOR_RESET}"

# 10. Clean vxlan
echo -e "${COLOR_CLEANUP}[CLEANUP] Deleting VXLAN...${COLOR_RESET}"
sudo "$SETUP_DIR/delete_vxlan.sh" # Should clean up VXLAN interfaces, bridges, and veths
echo -e "${COLOR_STATUS}[CLEANUP] VXLAN deleted.${COLOR_RESET}"

# 11. Clean namespaces
echo -e "${COLOR_CLEANUP}[CLEANUP] Deleting namespaces...${COLOR_RESET}"
sudo "$SETUP_DIR/delete_namespaces.sh" #
echo -e "${COLOR_STATUS}[CLEANUP] Namespaces deleted.${COLOR_RESET}"

echo -e "\n${COLOR_HEADER}===== NETWORK PERFORMANCE TEST RUN COMPLETE =====${COLOR_RESET}"
echo -e "${COLOR_STATUS}Results saved in ${RESULTS_DIR}${COLOR_RESET}"