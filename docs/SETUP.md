# Setup Guide

## Prerequisites

- Git
- curl
- sudo access

## Fresh Install

### Method 1: Using Makefile (Recommended)

#### 1. Install chezmoi

```bash
sh -c "$(curl -fsLS get.chezmoi.io)"
```

#### 2. Clone dotfiles

```bash
git clone https://github.com/YOUR-USERNAME/dotfiles.git ~/.local/share/chezmoi
cd ~/.local/share/chezmoi
```

#### 3. Preview changes

```bash
make diff
```

#### 4. Apply dotfiles

```bash
make apply -v
```

Answer prompts:
- Machine type (work/personal)
- Git name
- Git email
- Git signing key
- Codex base URL (work only)

#### 5. Install dependencies

```bash
make install
```

This will:
- Install Homebrew (if not present)
- Install 107+ packages and tools
- Install npm global packages
- Set up Oh My Zsh + Powerlevel10k
- Generate SSH keys

#### 6. Reload shell

```bash
exec zsh
```

### Method 2: Direct chezmoi

#### 1. Install chezmoi

```bash
sh -c "$(curl -fsLS get.chezmoi.io)"
```

#### 2. Initialize

```bash
chezmoi init https://github.com/YOUR-USERNAME/dotfiles.git
```

Answer the same prompts as above.

#### 3. Preview

```bash
chezmoi diff
```

#### 4. Apply

```bash
chezmoi apply -v
```

Auto-runs:
- Directory creation
- Package installation
- Oh My Zsh setup
- SSH key generation

#### 5. Reload Shell

```bash
exec zsh
```

## Makefile Workflow

The Makefile provides 30+ commands for managing your dotfiles:

### Essential Commands

```bash
make help              # Show all available commands
make diff              # Preview changes
make apply             # Apply dotfiles
make test              # Dry-run (safe testing)
make install           # Install all dependencies
make check             # Verify without applying
```

### Git Workflow

```bash
make git-status        # Check git status
make git-log           # View recent commits
make commit            # Commit changes (prompts for message)
make push              # Push to remote
make pull              # Pull from remote
make update            # Pull and apply in one command
```

### Editing

```bash
make edit              # Edit a dotfile (prompts for filename)
make add               # Add a file to chezmoi (prompts for path)
make remove            # Remove a file from chezmoi
```

### Package Management

```bash
make packages-darwin   # Install macOS packages only
make packages-linux    # Install Linux packages only
make setup-ohmyzsh     # Install Oh My Zsh
make setup-ssh         # Generate SSH keys
```

### Maintenance

```bash
make backup            # Backup current config
make clean             # Clean chezmoi cache
make doctor            # Diagnose issues
make verify            # Verify all files
make lint              # Lint shell scripts
make version           # Show tool versions
```

### Advanced

```bash
make data              # Show template data
make execute-template  # Test template expressions
make cd                # Open source directory
make docs              # View documentation
```

## Updating

### With Makefile

```bash
# Pull latest and apply
make update

# Or step by step
make pull
make apply
```

### Direct chezmoi

```bash
# Pull latest
chezmoi update

# Or manually
cd ~/.local/share/chezmoi
git pull
chezmoi apply
```

## Troubleshooting

### Reset Everything

```bash
make apply-force
# Or with chezmoi:
chezmoi init --apply --force
```

### Debug Templates

```bash
# Check variables
make data

# Test specific template
make execute-template
# Then enter: {{ .machine.type }}

# View file before apply
chezmoi cat ~/.zshrc
```

### Skip Scripts

```bash
# With chezmoi directly
chezmoi apply --exclude scripts
```

### Check Status

```bash
make status
make verify
make doctor
```

### View Changes

```bash
make diff              # See all changes
make git-log           # Recent commits
```

## Machine Detection

Auto-detects:
- **OS**: macOS/Linux
- **Distribution**: Arch/Ubuntu/Fedora
- **GUI**: X11/Wayland/macOS
- **Machine type**: Hostname contains "work"/"corp"/"talview"

Override in `~/.config/chezmoi/chezmoi.toml`:

```toml
[data.machine]
    type = "work"  # or "personal"
    hasGui = true
```

## Package Installation

The setup installs:
- **macOS**: 107+ Homebrew formulas + casks
- **Linux**: Core development tools via pacman/apt/dnf
- **npm**: 16+ global packages
- **Fonts**: 3 Nerd Fonts

Packages only install when:
- First time applying
- Package list changes (via `run_onchange_`)

## Makefile vs Direct Commands

| Task | Makefile | Direct chezmoi |
|------|----------|----------------|
| Apply changes | `make apply` | `chezmoi apply` |
| Show diff | `make diff` | `chezmoi diff` |
| Update | `make update` | `chezmoi update` |
| Commit | `make commit` | `cd ~/.local/share/chezmoi && git commit` |
| Install packages | `make install` | `chezmoi apply --include scripts` |
| Edit file | `make edit` | `chezmoi edit ~/.zshrc` |
| Test | `make test` | `chezmoi apply --dry-run` |

**Recommendation**: Use Makefile for consistency and additional features like backup, linting, and integrated git workflow.

## Next Steps

1. **Customize for your needs:**
   ```bash
   make edit  # Modify dotfiles
   make commit
   make push
   ```

2. **Install on another machine:**
   ```bash
   make init  # On new machine
   make apply
   ```

3. **Keep updated:**
   ```bash
   make update  # Regularly pull changes
   ```

4. **Explore commands:**
   ```bash
   make help  # See all available commands
   ```
