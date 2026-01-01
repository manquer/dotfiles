# Dotfiles

Personal development environment managed with [chezmoi](https://www.chezmoi.io/).

## Quick Start

### Using Makefile (Recommended)

```bash
# Install chezmoi
sh -c "$(curl -fsLS get.chezmoi.io)"

# Initialize from your repo
cd ~/.local/share/chezmoi
make init

# Preview changes
make diff

# Apply dotfiles
make apply

# Install all dependencies
make install
```

### Direct chezmoi commands

```bash
chezmoi init https://github.com/YOUR-USERNAME/dotfiles.git
chezmoi diff
chezmoi apply
```

## Makefile Commands

Run `make help` to see all available commands:

```bash
make help              # Show this help message
make init              # Initialize chezmoi (clone dotfiles repo)
make apply             # Apply dotfiles changes to the system
make diff              # Show differences between current state and dotfiles
make update            # Pull latest changes and apply
make test              # Test dotfiles in dry-run mode
make install           # Install dependencies (Homebrew, packages)
make commit            # Commit changes to dotfiles repo
make push              # Push dotfiles changes to remote
make backup            # Backup current system configuration
make docs              # View documentation
```

## Features

- **Machine profiles**: Work and personal configurations
- **OS support**: macOS and Linux (Arch, Ubuntu, Fedora)
- **GUI detection**: Installs GUI apps only when needed
- **Modular shell config**: Organized zsh configuration
- **Secret management**: Template-based sensitive data
- **Auto-install**: 107+ packages, tools, and npm globals
- **Makefile automation**: 30+ commands for workflow management

## Structure

```
dotfiles/
├── Makefile                    # Workflow automation (30+ targets)
├── .chezmoi.toml.tmpl          # Machine profile detection
├── .chezmoiignore              # Ignore patterns
├── README.md                   # This file
├── dot_config/
│   └── zsh/                    # Modular zsh config
│       ├── dot_zshenv.tmpl     # Environment variables
│       ├── dot_zprofile.tmpl   # Profile settings
│       └── conf.d/             # Config modules
├── run_once_*/                 # One-time setup scripts
├── run_onchange_*/             # Run when content changes
└── docs/                       # Detailed documentation
```

## Machine Profiles

The setup detects and configures based on:
- **Machine type**: work or personal
- **OS**: macOS or Linux
- **GUI**: Installs GUI apps only if detected

Set during first run or edit `~/.config/chezmoi/chezmoi.toml`.

## Daily Use

### With Makefile

```bash
make diff              # Check what will change
make apply             # Apply changes
make update            # Pull and apply latest
make commit            # Commit your changes
make push              # Push to remote
```

### Direct chezmoi

```bash
chezmoi edit ~/.zshrc  # Edit a file
chezmoi apply          # Apply changes
chezmoi update         # Update from repo
```

## Documentation

See [docs/](docs/) for detailed configuration explanations:
- [SETUP.md](docs/SETUP.md) - Installation and setup guide
- [SHELL.md](docs/SHELL.md) - Shell configuration details
- [GIT.md](docs/GIT.md) - Git settings and workflow
- [PACKAGES.md](docs/PACKAGES.md) - Package management

## Similar Setups

For inspiration, see:
- [holman/dotfiles](https://github.com/holman/dotfiles)
- [mathiasbynens/dotfiles](https://github.com/mathiasbynens/dotfiles)
- [alrra/dotfiles](https://github.com/alrra/dotfiles)
