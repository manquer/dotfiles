# Setup Guide

## Prerequisites

- Git
- curl
- sudo access

## Fresh Install

### 1. Install chezmoi

```bash
sh -c "$(curl -fsLS get.chezmoi.io)"
```

### 2. Initialize

```bash
chezmoi init https://github.com/YOUR-USERNAME/dotfiles.git
```

Answer prompts:
- Machine type (work/personal)
- Git name
- Git email
- Git signing key
- Codex base URL (work only)

### 3. Preview

```bash
chezmoi diff
```

### 4. Apply

```bash
chezmoi apply -v
```

Auto-runs:
- Directory creation
- Package installation
- Oh My Zsh setup
- SSH key generation

### 5. Reload Shell

```bash
exec zsh
```

## Updating

```bash
# Pull latest
chezmoi update

# Or manually
cd ~/.local/share/chezmoi
git pull
chezmoi apply
```

## Troubleshooting

### Reset

```bash
chezmoi init --apply --force
```

### Debug Templates

```bash
# Check variables
chezmoi execute-template '{{ .machine.type }}'
chezmoi execute-template '{{ .machine.hasGui }}'

# View file before apply
chezmoi cat ~/.zshrc
```

### Skip Scripts

```bash
# Skip run_* scripts
chezmoi apply --exclude scripts
```

## Machine Detection

Auto-detects:
- OS (macOS/Linux)
- Distribution (Arch)
- GUI (X11/Wayland/macOS)
- Machine type (hostname contains "work"/"corp"/"talview")

Override in `~/.config/chezmoi/chezmoi.toml`.
