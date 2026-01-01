# macOS Testing Setup

This directory contains configuration and documentation for testing dotfiles deployment on macOS using virtualization.

## Overview

Unlike Linux container testing (which uses Docker), macOS testing requires a VM solution since macOS cannot run in standard Linux containers. We support two approaches:

1. **Tart** (Recommended) - Native macOS virtualization using Apple's Virtualization.framework
2. **Lima** - Alternative VM manager with good macOS support

## Option 1: Tart (Recommended)

Tart is the recommended solution as it provides native macOS virtualization with better performance and easier setup.

### Installation

```bash
brew install cirruslabs/cli/tart
```

### Setup macOS VM

```bash
# Clone a base macOS image (Sonoma)
tart clone ghcr.io/cirruslabs/macos-sonoma-base:latest dotfiles-test-macos

# Start the VM (first run may take a few minutes)
tart run dotfiles-test-macos
```

### Configure SSH Access

Inside the VM:

1. Open **System Settings** > **General** > **Sharing**
2. Enable **Remote Login**
3. Note the username (usually `admin`)

From your host machine:

```bash
# Get the VM's IP address
tart ip dotfiles-test-macos

# Test SSH connection
ssh admin@$(tart ip dotfiles-test-macos)
```

### Update Ansible Inventory

Edit `testing/inventories/hosts.yml` and update the macOS host:

```yaml
macos_test:
  hosts:
    target-macos:
      ansible_host: 192.168.x.x  # Replace with actual VM IP
      ansible_port: 22
      ansible_user: admin
      ansible_password: admin  # Or use SSH key
```

### Running Tests

```bash
# From the testing directory
make test-macos
```

### Managing the VM

```bash
# List VMs
tart list

# Start VM in background
tart run --no-graphics dotfiles-test-macos

# Stop VM
tart stop dotfiles-test-macos

# Delete VM
tart delete dotfiles-test-macos
```

## Option 2: Lima

Lima is an alternative that provides a more Docker-like experience for macOS VMs.

### Installation

```bash
brew install lima
```

### Setup macOS VM

```bash
# Start a macOS VM with custom config
limactl start --name=dotfiles-test template://experimental/net-user-v2
```

### Configure SSH

```bash
# Get SSH connection info
limactl show-ssh dotfiles-test

# Test connection
limactl shell dotfiles-test
```

### Managing the VM

```bash
# List VMs
limactl list

# Stop VM
limactl stop dotfiles-test

# Delete VM
limactl delete dotfiles-test
```

## Testing Workflow

Once your macOS VM is running and accessible via SSH:

1. **Verify connectivity**:
   ```bash
   cd testing
   make check
   ```

2. **Run dry-run test**:
   ```bash
   make test-macos
   ```

3. **Apply dotfiles**:
   ```bash
   docker-compose run --rm ansible-control ansible-playbook \
     playbooks/test-dotfiles.yml -i inventories/hosts.yml -l target-macos
   ```

4. **Verify results**:
   ```bash
   make verify
   ```

## Troubleshooting

### Cannot connect to VM

- Ensure Remote Login is enabled in System Settings
- Check firewall settings
- Verify the IP address with `tart ip` or `limactl show-ssh`

### Ansible connection fails

- Test SSH connection manually first
- Check ansible_user and ansible_password in inventory
- Consider using SSH key authentication instead of password

### VM performance issues

- Allocate more CPU/RAM to the VM (see Tart/Lima config)
- Close other resource-intensive applications
- Use `--no-graphics` flag for headless operation

## Differences from Linux Testing

| Aspect | Linux (Docker) | macOS (VM) |
|--------|----------------|------------|
| Speed | Fast (containers) | Slower (full VM) |
| Isolation | Process-level | Full OS isolation |
| Setup | Automatic | Manual VM configuration |
| Resources | Lightweight | Heavier (requires full macOS) |
| Networking | Bridge network | NAT or bridged |

## Best Practices

1. **Snapshot VMs**: Create snapshots before testing to quickly restore clean state
2. **Automate setup**: Script the VM creation and SSH configuration
3. **Use SSH keys**: Avoid password authentication for better security
4. **Resource allocation**: Give VM sufficient resources (4GB+ RAM, 2+ CPUs)
5. **Network consistency**: Use static IPs or update inventory dynamically

## Future Improvements

- [ ] Automate VM provisioning with Tart scripts
- [ ] Add GitHub Actions workflow for macOS testing
- [ ] Create pre-configured VM images with SSH enabled
- [ ] Add macOS version matrix testing (Sonoma, Ventura)
- [ ] Integrate with CI/CD pipeline
