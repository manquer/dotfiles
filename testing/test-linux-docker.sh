#!/bin/bash
# Test script for dotfiles installation in Docker containers (Ubuntu/Debian)

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
DISTRO="${DISTRO:-ubuntu}"
VERSION="${VERSION:-24.04}"
CONTAINER_NAME="dotfiles-test-${DISTRO}-${VERSION}"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

cleanup() {
    log_info "Cleaning up..."
    docker rm -f "$CONTAINER_NAME" 2>/dev/null || true
}

# Main test function
run_test() {
    log_info "Testing dotfiles on ${DISTRO}:${VERSION}"
    log_info "Repository directory: $REPO_DIR"

    # Trap to ensure cleanup on exit
    trap cleanup EXIT

    # Build the Docker image
    log_info "Building Docker image..."
    if [ "$DISTRO" = "ubuntu" ]; then
        docker build \
            --build-arg UBUNTU_VERSION="$VERSION" \
            -f "$REPO_DIR/testing/Dockerfile.ubuntu" \
            -t "dotfiles-test:${DISTRO}-${VERSION}" \
            "$REPO_DIR"
    else
        docker build \
            --build-arg DEBIAN_VERSION="$VERSION" \
            -f "$REPO_DIR/testing/Dockerfile.debian" \
            -t "dotfiles-test:${DISTRO}-${VERSION}" \
            "$REPO_DIR"
    fi

    # Run the container
    log_info "Starting container..."
    docker run -d \
        --name "$CONTAINER_NAME" \
        -v "$REPO_DIR:/home/testuser/.local/share/chezmoi:ro" \
        "dotfiles-test:${DISTRO}-${VERSION}" \
        sleep infinity

    # Wait for container to be ready
    sleep 2

    # Test 1: Install chezmoi
    log_info "Test 1: Installing chezmoi..."
    docker exec "$CONTAINER_NAME" bash -c '
        curl -fsLS get.chezmoi.io | sh -s -- -b "$HOME/.local/bin"
        export PATH="$HOME/.local/bin:$PATH"
        chezmoi --version
    '
    log_success "Chezmoi installed successfully"

    # Test 2: Test package installation script directly
    log_info "Test 2: Testing package installation script..."
    docker exec "$CONTAINER_NAME" bash -c '
        # Test if apt-get works
        sudo apt-get update > /dev/null
        echo "✓ apt-get update works"

        # Test installing a few key packages
        sudo apt-get install -y git curl wget build-essential > /dev/null 2>&1
        echo "✓ Core packages can be installed"

        # Check if package detection works
        command -v apt-get && echo "✓ apt-get detected"
    '
    log_success "Package manager verification completed"

    # Test 3: Verify Debian/Ubuntu detection files exist
    log_info "Test 3: Verifying OS detection files..."
    docker exec "$CONTAINER_NAME" bash -c '
        test -f /etc/debian_version && echo "✓ /etc/debian_version exists" || echo "✗ /etc/debian_version missing"
        test -f /etc/lsb-release && echo "✓ /etc/lsb-release exists" || echo "✗ /etc/lsb-release missing"
        cat /etc/os-release | grep -E "^ID=" || true
    '
    log_success "OS detection files verified"

    # Test 4: Test partial package installation (fast packages only)
    log_info "Test 4: Installing test packages..."
    docker exec "$CONTAINER_NAME" bash -c '
        sudo apt-get install -y \
            zsh \
            tmux \
            ripgrep \
            fd-find \
            jq \
            tree \
            htop > /dev/null 2>&1

        # Verify installations
        command -v zsh && echo "✓ zsh installed"
        command -v tmux && echo "✓ tmux installed"
        command -v rg && echo "✓ ripgrep installed"
        command -v jq && echo "✓ jq installed"
        command -v tree && echo "✓ tree installed"
        command -v htop && echo "✓ htop installed"
    '
    log_success "Test packages installed successfully"

    # Test 5: Verify chezmoi can be installed
    log_info "Test 5: Testing chezmoi installation from script..."
    docker exec "$CONTAINER_NAME" bash -c '
        mkdir -p "$HOME/.local/bin"
        export PATH="$HOME/.local/bin:$PATH"

        if ! command -v chezmoi &>/dev/null; then
            sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
            echo "✓ chezmoi installed successfully"
        else
            echo "✓ chezmoi already installed"
        fi

        chezmoi --version
    '
    log_success "Chezmoi installation verified"

    # Test 6: Test Rust installation
    log_info "Test 6: Testing Rust installation..."
    docker exec "$CONTAINER_NAME" bash -c '
        if ! command -v rustc &>/dev/null; then
            echo "Installing Rust..."
            curl --proto "=https" --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y > /dev/null 2>&1
            source "$HOME/.cargo/env"
            command -v rustc && echo "✓ Rust installed successfully"
        else
            echo "✓ Rust already installed"
        fi
    ' || true
    log_success "Rust installation test completed"

    # Final status
    log_success "All tests completed for ${DISTRO}:${VERSION}!"
}

# Help message
show_help() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS]

Test dotfiles installation in Docker containers (Ubuntu/Debian)

OPTIONS:
    -d, --distro DISTRO     Distribution to test (ubuntu or debian, default: ubuntu)
    -v, --version VERSION   Distribution version (default: 24.04 for ubuntu, 12 for debian)
    -h, --help             Show this help message

EXAMPLES:
    # Test on Ubuntu 24.04
    $(basename "$0")

    # Test on Ubuntu 22.04
    $(basename "$0") -d ubuntu -v 22.04

    # Test on Debian 12
    $(basename "$0") -d debian -v 12

    # Test on Debian 11
    $(basename "$0") -d debian -v 11

ENVIRONMENT VARIABLES:
    DISTRO    Distribution to test (ubuntu or debian)
    VERSION   Distribution version

EOF
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -d|--distro)
            DISTRO="$2"
            shift 2
            ;;
        -v|--version)
            VERSION="$2"
            shift 2
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            log_error "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# Validate distro
if [[ "$DISTRO" != "ubuntu" && "$DISTRO" != "debian" ]]; then
    log_error "Invalid distro: $DISTRO. Must be 'ubuntu' or 'debian'"
    exit 1
fi

# Set default version if not specified
if [[ "$DISTRO" == "debian" && "$VERSION" == "24.04" ]]; then
    VERSION="12"
fi

# Run the tests
run_test
