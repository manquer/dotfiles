# Dotfiles Testing

Automated testing for dotfiles using Docker (Linux) and VM (macOS) with Ansible.

## Overview

This testing framework allows you to verify dotfiles deployment on:
- **Linux**: Arch Linux using Docker containers
- **macOS**: Sonoma/Ventura using Tart or Lima VMs (see `macos/README.md`)

## Architecture

```
testing/
├── Makefile                    # Testing automation
├── Dockerfile                  # Ansible control node
├── docker-compose.yml          # Arch Linux test environment
├── ansible.cfg                 # Ansible configuration
├── playbooks/
│   └── test-dotfiles.yml      # Main test playbook
├── inventories/
│   └── hosts.yml              # Test target inventory (Linux + macOS)
├── vars/
│   └── test-config.yml        # Test variables
├── templates/
│   └── test-report.j2         # Test report template
├── macos/
│   └── README.md              # macOS VM testing setup
└── logs/                       # Test logs and artifacts
```

## Quick Start

### Run All Tests

```bash
# From dotfiles root
make test-docker

# Or from testing directory
cd testing
make full-test
```

### Step by Step

```bash
# 1. Build Ansible control container
make test-docker-build

# 2. Start test targets
make test-docker-up

# 3. Run tests
cd testing
make run

# 4. View results
make verify

# 5. Clean up
make test-docker-down
```

## Test Targets

### Linux (Docker)

| Target | OS | IP | Port |
|--------|----|----|------|
| target-arch | Arch Linux | 172.29.0.10 | 2222 |

### macOS (VM)

macOS testing requires a separate VM setup using Tart or Lima. See `macos/README.md` for detailed instructions.

| Target | OS | Setup Required |
|--------|----|----|
| target-macos | macOS Sonoma | Tart/Lima VM + SSH |

## Available Commands

### From Dotfiles Root

```bash
make test-docker           # Run full test suite
make test-docker-build     # Build test environment
make test-docker-up        # Start containers
make test-docker-down      # Stop containers
make test-docker-clean     # Remove everything
make test-docker-shell     # Interactive shell
make test-docker-verify    # View test reports
```

### From testing/ Directory

```bash
make help              # Show all commands
make full-test         # Complete workflow (Arch Linux)
make build             # Build Ansible container
make up                # Start Arch Linux container
make down              # Stop containers
make clean             # Remove containers and volumes
make test              # Dry-run test
make run               # Run actual tests
make check             # Ping all targets
make shell             # Ansible control shell
make logs              # View container logs
make verify            # Show test reports
make lint              # Lint playbooks
make syntax            # Check syntax
make facts             # Gather system facts
make version           # Show Ansible version
make test-arch         # Test Arch Linux
make test-linux        # Alias for test-arch
make test-macos        # Test macOS (requires VM setup)
```

## What Gets Tested

1. **Chezmoi Installation**
   - Binary installation
   - Version verification

2. **Dotfiles Initialization**
   - Repository mounting
   - Source directory setup

3. **Configuration Validation**
   - Template processing
   - Package scripts presence
   - Dry-run execution

4. **OS Compatibility**
   - Linux: Arch Linux (pacman)
   - macOS: Sonoma/Ventura (Homebrew)

5. **Script Verification**
   - Linux package installation scripts (Arch)
   - macOS package installation scripts (Homebrew)
   - Run-once scripts
   - Run-onchange scripts

## Test Reports

Reports are generated in `/tmp/dotfiles-test-report-<target>.txt`:

```
Dotfiles Testing Report
======================
Host: target-arch
Date: 2025-12-31T15:30:00Z

System Information
------------------
OS: Arch Linux
Architecture: x86_64

Test Results
------------
Dry-run Status: PASSED
Exit Code: 0

Verification
------------
✓ Chezmoi installed successfully
✓ Dotfiles repository accessible
✓ Dry-run completed
✓ Package scripts present
```

## Workflow Examples

### Test Before Commit

```bash
# Make changes to dotfiles
vim ~/.local/share/chezmoi/dot_zshrc.tmpl

# Test changes
make test-docker

# If passed, commit
make commit
make push
```

### Test Specific OS

```bash
cd testing

# Test on Arch Linux
make test-arch

# Test on macOS (requires VM setup)
make test-macos
```

### Debug Issues

```bash
# Start containers
make test-docker-up

# Open shell in control node
make test-docker-shell

# Inside container:
ansible all -m ping -i inventories/hosts.yml
ansible-playbook playbooks/test-dotfiles.yml -i inventories/hosts.yml -vvv
```

### View Logs

```bash
# Real-time logs
cd testing
make logs

# Ansible logs
cat testing/logs/ansible.log

# Test reports
make verify
```

## Customization

### Add New Test Target

Edit `docker-compose.yml`:

```yaml
  target-fedora:
    image: fedora:latest
    container_name: dotfiles-target-fedora
    # ... similar setup
```

Add to `inventories/hosts.yml`:

```yaml
  target-fedora:
    ansible_host: 172.29.0.13
    ansible_port: 22
    os_family: RedHat
```

### Modify Test Variables

Edit `vars/test-config.yml`:

```yaml
test_machine_type: work  # Change to work profile
skip_gui_apps: false     # Test GUI apps
```

### Add Test Tasks

Edit `playbooks/test-dotfiles.yml`:

```yaml
- name: Custom test task
  ansible.builtin.command: your-test-command
```

## Troubleshooting

### Containers Won't Start

```bash
# Check Docker
docker ps -a

# View container logs
docker logs dotfiles-target-ubuntu

# Rebuild
make test-docker-clean
make test-docker-build
```

### SSH Connection Failed

```bash
# Check container networking
docker network inspect testing_dotfiles-test

# Test manual connection to Arch container
ssh -p 2222 testuser@172.29.0.10
# Password: testpass

# Test macOS VM connection (if using Tart)
ssh admin@$(tart ip dotfiles-test-macos)
```

### Ansible Playbook Errors

```bash
# Verbose mode
cd testing
docker-compose run --rm dotfiles-ansible-control \
  ansible-playbook playbooks/test-dotfiles.yml \
  -i inventories/hosts.yml -vvv
```

### Clean Slate

```bash
# Remove everything
make test-docker-clean

# Rebuild from scratch
make test-docker-build
make test-docker
```

## CI/CD Integration

### GitHub Actions

```yaml
name: Test Dotfiles

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run tests
        run: make test-docker
```

### GitLab CI

```yaml
test-dotfiles:
  image: docker:latest
  services:
    - docker:dind
  script:
    - cd testing
    - make full-test
```

## Best Practices

1. **Test before commit**
   ```bash
   make test-docker && make commit
   ```

2. **Clean between runs**
   ```bash
   make test-docker-clean
   make test-docker
   ```

3. **Use verbose mode for debugging**
   ```bash
   cd testing
   make run ANSIBLE_OPTS="-vvv"
   ```

4. **Keep test environment updated**
   ```bash
   make test-docker-build --no-cache
   ```

5. **Review test reports**
   ```bash
   make test-docker-verify
   ```

## Requirements

### Linux Testing (Docker)
- Docker
- Docker Compose
- Make
- 1GB+ RAM
- 3GB+ disk space

### macOS Testing (VM)
- Tart or Lima (VM solution)
- 4GB+ RAM for VM
- 10GB+ disk space for VM image

## Support

For issues or questions:
1. Check test reports: `make test-docker-verify`
2. View logs: `cd testing && make logs`
3. Debug: `make test-docker-shell`
