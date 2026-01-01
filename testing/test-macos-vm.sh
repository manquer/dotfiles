#!/bin/bash
set -e

# macOS VM Testing Script
# Starts Tart VM and runs Ansible dotfiles tests

# Configuration
VM_NAME="${TART_VM_NAME:-dotfiles-test-macos}"
VM_USER="${TART_VM_USER:-admin}"
BOOT_WAIT="${TART_BOOT_WAIT:-30}"
MAX_IP_RETRIES="${TART_IP_RETRIES:-10}"
SSH_TIMEOUT="${TART_SSH_TIMEOUT:-300}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="${SCRIPT_DIR}/logs"
LOG_FILE="${LOG_DIR}/vm-test-$(date +%Y%m%d-%H%M%S).log"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Create log directory
mkdir -p "$LOG_DIR"

# Logging function
log() {
    local level="$1"
    shift
    local message="$@"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] [$level] $message" | tee -a "$LOG_FILE"
}

log_info() {
    echo -e "${BLUE}[INFO]${NC} $@" | tee -a "$LOG_FILE"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $@" | tee -a "$LOG_FILE"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $@" | tee -a "$LOG_FILE"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $@" | tee -a "$LOG_FILE"
}

# Cleanup function
cleanup() {
    local exit_code=$?
    if [ $exit_code -ne 0 ]; then
        log_error "Script failed with exit code $exit_code"
        log_info "Full logs available at: $LOG_FILE"

        # Dump VM logs if available
        if [ -n "$VM_NAME" ] && tart list | grep -q "$VM_NAME.*running"; then
            log_info "Attempting to collect VM diagnostics..."
            log stream --predicate='process=="tart" OR process CONTAINS "Virtualization"' --last 5m >> "$LOG_FILE" 2>&1 || true
        fi
    fi
    exit $exit_code
}

trap cleanup EXIT INT TERM

# Validation: Check if tart is installed
log_info "Validating prerequisites..."
if ! command -v tart &> /dev/null; then
    log_error "Tart not installed"
    log_info "Install with: brew install cirruslabs/cli/tart"
    exit 1
fi
log_success "Tart is installed ($(tart --version 2>&1 || echo 'version unknown'))"

# Validation: Check if docker-compose is available
if ! command -v docker-compose &> /dev/null; then
    log_error "docker-compose not installed"
    log_info "Install Docker Desktop or docker-compose"
    exit 1
fi
log_success "docker-compose is installed"

# Validation: Check if VM exists (must be a local VM, not OCI)
log_info "Checking for local VM: $VM_NAME"
if ! tart list | grep "^local" | grep -q "$VM_NAME"; then
    log_error "Local VM '$VM_NAME' not found"
    log_info "Available local VMs:"
    tart list | grep "^local" | tee -a "$LOG_FILE" || echo "  (none)" | tee -a "$LOG_FILE"
    log_info ""
    log_info "Available OCI images:"
    tart list | grep "^OCI" | tee -a "$LOG_FILE" || echo "  (none)" | tee -a "$LOG_FILE"
    log_info ""
    log_info "To clone an OCI image to a local VM:"
    log_info "  tart clone ghcr.io/cirruslabs/macos-sequoia-base:latest $VM_NAME"
    exit 1
fi
log_success "Local VM '$VM_NAME' found"

# Start VM if not running
if ! tart list | grep -q "$VM_NAME.*running"; then
    log_info "Starting Tart VM: $VM_NAME"

    # Start streaming VM logs in background
    log_info "Starting VM log collection..."
    log stream --predicate='process=="tart" OR process CONTAINS "Virtualization"' >> "$LOG_FILE" 2>&1 &
    LOG_STREAM_PID=$!

    # Start VM in background
    tart run --no-graphics "$VM_NAME" >> "$LOG_FILE" 2>&1 &
    TART_PID=$!

    log_info "VM starting (PID: $TART_PID), waiting ${BOOT_WAIT}s for boot..."
    sleep "$BOOT_WAIT"

    # Validate VM is still running
    if ! tart list | grep -q "$VM_NAME.*running"; then
        log_error "VM failed to start or crashed during boot"
        log_info "Check logs at: $LOG_FILE"
        exit 1
    fi
    log_success "VM is running"
else
    log_success "VM $VM_NAME is already running"
fi

# Get VM IP with retry logic
log_info "Getting VM IP address (max $MAX_IP_RETRIES retries)..."
VM_IP=""
for i in $(seq 1 $MAX_IP_RETRIES); do
    VM_IP=$(tart ip "$VM_NAME" 2>&1 || true)
    if [ -n "$VM_IP" ] && [[ "$VM_IP" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        log_success "VM IP: $VM_IP (attempt $i/$MAX_IP_RETRIES)"
        break
    fi
    if [ $i -eq $MAX_IP_RETRIES ]; then
        log_error "Could not get VM IP after $MAX_IP_RETRIES attempts"
        log_info "VM status:"
        tart list | grep "$VM_NAME" | tee -a "$LOG_FILE"
        exit 1
    fi
    log_warning "Waiting for VM IP... (attempt $i/$MAX_IP_RETRIES)"
    sleep 3
done

# Validate IP address
if [ -z "$VM_IP" ]; then
    log_error "VM IP is empty"
    exit 1
fi

# Test network connectivity
log_info "Testing network connectivity to VM..."
if ! ping -c 3 -t 5 "$VM_IP" >> "$LOG_FILE" 2>&1; then
    log_warning "Ping to VM failed, but continuing (VM might have firewall rules)"
else
    log_success "VM is reachable via ping"
fi

# Test SSH connectivity with timeout
log_info "Testing SSH connectivity (timeout: ${SSH_TIMEOUT}s)..."
if timeout "$SSH_TIMEOUT" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 -o BatchMode=yes "$VM_USER@$VM_IP" echo "SSH connection successful" >> "$LOG_FILE" 2>&1; then
    log_success "SSH connection established"
else
    log_warning "SSH test failed - Ansible will attempt with its own configuration"
fi

# Run Ansible tests
log_info "Running Ansible dotfiles tests..."
log_info "Output will be streamed below and saved to: $LOG_FILE"
log_info "========================================"

cd "$SCRIPT_DIR"

# Build the ansible-control container first to validate
log_info "Building Ansible control container..."
if ! docker-compose build ansible-control >> "$LOG_FILE" 2>&1; then
    log_error "Failed to build ansible-control container"
    log_info "Check logs at: $LOG_FILE"
    exit 1
fi
log_success "Ansible control container built"

# Run Ansible tests with streaming output
log_info "Starting Ansible playbook execution..."
set +e  # Don't exit immediately on error, we want to capture the exit code
docker-compose run --rm ansible-control \
  ansible-playbook playbooks/test-dotfiles.yml \
  -i inventories/hosts.yml \
  -l target-macos \
  -e "ansible_host=$VM_IP" \
  -e "ansible_port=22" \
  -e "ansible_user=$VM_USER" \
  -vv \
  "$@" 2>&1 | tee -a "$LOG_FILE"

ANSIBLE_EXIT_CODE=${PIPESTATUS[0]}
set -e

log_info "========================================"
if [ $ANSIBLE_EXIT_CODE -eq 0 ]; then
    log_success "Tests completed successfully!"
    log_info "Full logs available at: $LOG_FILE"
    exit 0
else
    log_error "Tests failed with exit code $ANSIBLE_EXIT_CODE"
    log_info "Full logs available at: $LOG_FILE"
    exit $ANSIBLE_EXIT_CODE
fi
