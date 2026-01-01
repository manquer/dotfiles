#!/bin/bash
set -e

# macOS VM Testing Script
# Starts Tart VM and runs Ansible dotfiles tests

# Configuration
VM_NAME="${TART_VM_NAME:-dotfiles-test-macos}"
VM_USER="${TART_VM_USER:-admin}"
BOOT_WAIT="${TART_BOOT_WAIT:-15}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if tart is installed
if ! command -v tart &> /dev/null; then
    echo -e "${RED}Error: Tart not installed.${NC}"
    echo "Install with: brew install cirruslabs/cli/tart"
    exit 1
fi

# Check if VM exists
if ! tart list | grep -q "$VM_NAME"; then
    echo -e "${RED}Error: VM '$VM_NAME' not found.${NC}"
    echo "Available VMs:"
    tart list
    echo ""
    echo "To clone a VM:"
    echo "  tart clone ghcr.io/cirruslabs/macos-sequoia-base:latest $VM_NAME"
    exit 1
fi

# Start VM if not running
if ! tart list | grep -q "$VM_NAME.*running"; then
    echo -e "${YELLOW}Starting Tart VM: $VM_NAME${NC}"
    tart run --no-graphics "$VM_NAME" &
    echo "Waiting ${BOOT_WAIT}s for VM to boot..."
    sleep "$BOOT_WAIT"
else
    echo -e "${GREEN}VM $VM_NAME is already running${NC}"
fi

# Get VM IP
echo "Getting VM IP address..."
VM_IP=$(tart ip "$VM_NAME")
if [ -z "$VM_IP" ]; then
    echo -e "${RED}Error: Could not get VM IP. Is the VM running?${NC}"
    exit 1
fi

echo -e "${GREEN}VM IP: $VM_IP${NC}"

# Test SSH connection (skip if using Ansible with its own keys)
echo "Testing SSH connection..."
echo -e "${YELLOW}Note: SSH authentication is handled by Ansible${NC}"

# Run Ansible tests
echo -e "${YELLOW}Running Ansible dotfiles tests...${NC}"
cd "$SCRIPT_DIR"

docker-compose run --rm ansible-control \
  ansible-playbook playbooks/test-dotfiles.yml \
  -i inventories/hosts.yml \
  -l target-macos \
  -e "ansible_host=$VM_IP" \
  -e "ansible_port=22" \
  -e "ansible_user=$VM_USER" \
  "$@"

echo -e "${GREEN}Tests completed!${NC}"
