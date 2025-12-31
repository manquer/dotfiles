# Dotfiles

Personal development environment managed with [chezmoi](https://www.chezmoi.io/).

## Quick Start

```bash
# Install chezmoi
sh -c "$(curl -fsLS get.chezmoi.io)"

# Initialize
chezmoi init https://github.com/YOUR-USERNAME/dotfiles.git

# Preview changes
chezmoi diff

# Apply
chezmoi apply
```

## Features

- **Machine profiles**: Work and personal configurations
- **OS support**: macOS and Linux (Arch, Ubuntu, Fedora)
- **GUI detection**: Installs GUI apps only when needed
- **Modular shell config**: Organized zsh configuration
- **Secret management**: Template-based sensitive data
- **Auto-install**: Packages, tools, and npm globals

## Structure

```
dotfiles/
├── .chezmoi.toml.tmpl          # Machine profile detection
├── .chezmoiignore              # Ignore patterns
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

## Documentation

See [docs/](docs/) for detailed configuration explanations.

## Daily Use

```bash
# Edit a file
chezmoi edit ~/.zshrc

# Apply changes
chezmoi apply

# Update from repo
chezmoi update
```

## Similar Setups

For inspiration, see:
- [holman/dotfiles](https://github.com/holman/dotfiles)
- [mathiasbynens/dotfiles](https://github.com/mathiasbynens/dotfiles)
- [alrra/dotfiles](https://github.com/alrra/dotfiles)
