# Dotfiles

Cross-platform development environment managed with [chezmoi](https://www.chezmoi.io/). Supports macOS and Linux (Arch, Ubuntu, Fedora) with automatic machine profile detection for work and personal configurations.

## Architecture Overview

```
                              chezmoi init
                                   │
                                   ▼
                    ┌──────────────────────────────┐
                    │    .chezmoi.toml.tmpl        │
                    │  ┌────────────────────────┐  │
                    │  │  Machine Detection     │  │
                    │  │  - OS (darwin/linux)   │  │
                    │  │  - Type (work/personal)│  │
                    │  │  - GUI environment     │  │
                    │  └────────────────────────┘  │
                    └──────────────────────────────┘
                                   │
            ┌──────────────────────┼──────────────────────┐
            │                      │                      │
            ▼                      ▼                      ▼
    ┌───────────────┐    ┌─────────────────┐    ┌─────────────────┐
    │ run_once_*    │    │ run_onchange_*  │    │  Config Files   │
    │ ────────────  │    │ ─────────────── │    │ ─────────────── │
    │ • Directories │    │ • Packages      │    │ • Shell (zsh)   │
    │ • Oh My Zsh   │    │   (brew/pacman) │    │ • Git           │
    │ • SSH keys    │    │ • npm globals   │    │ • Neovim        │
    └───────────────┘    └─────────────────┘    │ • Tmux, Kitty   │
                                                │ • Atuin, gh     │
                                                └─────────────────┘
```

## Features

| Feature | Description |
|---------|-------------|
| **Machine Profiles** | Auto-detects work/personal from hostname, configures accordingly |
| **OS Support** | macOS, Arch Linux, Ubuntu, Fedora, Debian |
| **108+ Packages** | Development tools, CLI utilities, DevOps, languages |
| **Modular Shell** | Organized zsh with Oh My Zsh + Powerlevel10k |
| **Neovim Setup** | Full Lua config with LSP, completion, AI tools |
| **Secret Management** | Template-based sensitive data handling |
| **GUI Detection** | Installs desktop apps only when GUI is available |
| **Automated Testing** | Docker (Linux) and VM (macOS) test infrastructure |

## Quick Start

```bash
# Install chezmoi
sh -c "$(curl -fsLS get.chezmoi.io)"

# Initialize (will prompt for machine type, git info)
chezmoi init https://github.com/YOUR-USERNAME/dotfiles.git

# Preview changes
chezmoi diff

# Apply dotfiles and install packages
chezmoi apply

# Reload shell
exec zsh
```

Or use the Makefile:

```bash
git clone https://github.com/YOUR-USERNAME/dotfiles.git ~/.local/share/chezmoi
cd ~/.local/share/chezmoi
make diff      # Preview
make apply     # Apply
make install   # Install packages
```

## Documentation

| Document | Description |
|----------|-------------|
| [ARCHITECTURE](docs/ARCHITECTURE.md) | System design, initialization flow, component relationships |
| [SETUP](docs/SETUP.md) | Installation guide, prerequisites, troubleshooting |
| [TEMPLATES](docs/TEMPLATES.md) | Chezmoi templating system and variables |
| [PROFILES](docs/PROFILES.md) | Work/personal profiles, auto-detection, customization |
| [SCRIPTS](docs/SCRIPTS.md) | Setup scripts (run_once, run_onchange) |
| [SHELL](docs/SHELL.md) | Zsh configuration, Oh My Zsh, aliases |
| [GIT](docs/GIT.md) | Git settings, delta, GPG signing |
| [NEOVIM](docs/NEOVIM.md) | Full Neovim configuration and plugins |
| [PACKAGES](docs/PACKAGES.md) | Complete package list by category |
| [TOOLS](docs/TOOLS.md) | Tool configurations (Atuin, gh, tmux, etc.) |
| [MAKEFILE](docs/MAKEFILE.md) | All 30+ Makefile commands |

## Testing

Automated testing ensures dotfiles work across platforms:

```bash
# Run full test suite (Docker)
make test-docker

# Test specific OS
cd testing
make test-arch    # Arch Linux
make test-macos   # macOS (requires VM)
```

See [testing/README.md](testing/README.md) for full testing documentation.

## Repository Structure

```
dotfiles/
├── .chezmoi.toml.tmpl              # Machine detection & variables
├── .chezmoiignore                  # Excluded files
├── Makefile                        # 30+ workflow commands
│
├── dot_zshrc.tmpl                  # Main zsh config
├── dot_gitconfig.tmpl              # Git configuration
├── dot_tmux.conf                   # Tmux configuration
│
├── dot_config/
│   ├── nvim/                       # Neovim (Lua config)
│   ├── zsh/conf.d/                 # Modular zsh configs
│   ├── kitty/                      # Kitty terminal
│   ├── atuin/                      # Shell history sync
│   └── gh/                         # GitHub CLI
│
├── run_once_before_*               # One-time setup (directories)
├── run_once_after_*                # Post-apply setup (oh-my-zsh, ssh)
├── run_onchange_*                  # Triggered on changes (packages)
│
├── docs/                           # Documentation
└── testing/                        # Test infrastructure
    ├── docker-compose.yml          # Linux test containers
    ├── playbooks/                  # Ansible test playbooks
    └── macos/                      # macOS VM testing
```

## Daily Workflow

```bash
# Check what would change
make diff

# Apply changes
make apply

# Pull updates from remote
make update

# Make changes, commit, push
make commit
make push
```

## Requirements

- **All platforms**: Git, curl, sudo access
- **macOS**: Homebrew (auto-installed)
- **Linux**: Package manager (pacman, apt, dnf)
- **Testing**: Docker, Docker Compose, Make

## What Gets Installed

**Development**: neovim, git, gh, asdf, node, python, go, rust, docker, kubectl

**CLI Tools**: ripgrep, fd, bat, eza, fzf, jq, yq, httpie, tldr

**Shell**: zsh, Oh My Zsh, Powerlevel10k, atuin, zoxide, direnv

**DevOps**: terraform, ansible, helm, awscli, azure-cli

**GUI Apps** (if detected): iTerm2, Chrome, Slack, Notion, Raycast

See [PACKAGES.md](docs/PACKAGES.md) for the complete list of 108+ packages.

## Contributing

1. Fork the repository
2. Make changes in your fork
3. Test with `make test-docker`
4. Submit a pull request

## License

MIT
