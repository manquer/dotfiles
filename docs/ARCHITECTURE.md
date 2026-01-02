# Architecture

This document explains how the dotfiles system is designed, how components interact, and the order in which things are initialized.

## System Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           chezmoi init / apply                              │
└─────────────────────────────────────────────────────────────────────────────┘
                                      │
                                      ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                         .chezmoi.toml.tmpl                                  │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │ 1. Detect OS (darwin/linux)                                          │   │
│  │ 2. Detect machine type (work/personal from hostname)                 │   │
│  │ 3. Detect GUI environment (X11/Wayland/macOS)                        │   │
│  │ 4. Prompt for git credentials and work-specific settings             │   │
│  │ 5. Generate template variables (.machine, .git, .codex)              │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────────────┘
                                      │
           ┌──────────────────────────┼──────────────────────────┐
           │                          │                          │
           ▼                          ▼                          ▼
┌───────────────────────┐  ┌───────────────────────┐  ┌───────────────────────┐
│   run_once_before_*   │  │   run_onchange_*      │  │    Config Files       │
│   (First-time setup)  │  │   (On content change) │  │    (Templates)        │
├───────────────────────┤  ├───────────────────────┤  ├───────────────────────┤
│ • Create directories  │  │ • Install packages    │  │ • Shell configs       │
│                       │  │   (Homebrew/pacman)   │  │ • Git configuration   │
│                       │  │ • npm global packages │  │ • Neovim setup        │
│                       │  │                       │  │ • Tool configs        │
└───────────────────────┘  └───────────────────────┘  └───────────────────────┘
           │                          │                          │
           ▼                          ▼                          │
┌───────────────────────┐  ┌───────────────────────┐             │
│   run_once_after_*    │  │     Config Files      │◄────────────┘
│   (Post-apply setup)  │  │     Applied to ~      │
├───────────────────────┤  └───────────────────────┘
│ • Install Oh My Zsh   │
│ • Generate SSH keys   │
└───────────────────────┘
```

## Initialization Flow

When you run `chezmoi init` or `chezmoi apply`, the following happens in order:

### Phase 1: Configuration

1. **Template Processing** - `.chezmoi.toml.tmpl` is evaluated
   - OS detection via `{{ .chezmoi.os }}`
   - Machine type from hostname patterns
   - GUI detection from environment variables
   - User prompted for git credentials

2. **Config Generated** - `~/.config/chezmoi/chezmoi.toml` created with:
   ```toml
   [data.machine]
       type = "work"
       os = "darwin"
       hasGui = true
       # ... more variables

   [data.git]
       name = "Your Name"
       email = "email@example.com"
   ```

### Phase 2: Before Scripts

Scripts run in alphabetical order before files are applied:

| Order | Script | Purpose |
|-------|--------|---------|
| 00 | `run_once_before_00-setup-directories.sh` | Creates `~/Projects`, `~/.config`, `~/.local/{bin,share,state}` |

**Note**: `run_onchange_before_*` scripts also run here if their content changed:

| Script | Purpose | Trigger |
|--------|---------|---------|
| `run_onchange_before_install-packages-darwin.sh.tmpl` | Install Homebrew + 108 packages | Package list changes |
| `run_onchange_before_install-packages-linux.sh.tmpl` | Install via pacman/apt/dnf | Package list changes |

### Phase 3: File Application

Config files are templated and applied:

- `dot_zshrc.tmpl` → `~/.zshrc`
- `dot_gitconfig.tmpl` → `~/.gitconfig`
- `dot_config/nvim/*` → `~/.config/nvim/*`
- etc.

### Phase 4: After Scripts

| Order | Script | Purpose |
|-------|--------|---------|
| 01 | `run_once_after_01-install-ohmyzsh.sh.tmpl` | Install Oh My Zsh + Powerlevel10k theme |
| 02 | `run_once_after_02-generate-ssh-keys.sh.tmpl` | Generate Ed25519 SSH key, add to macOS keychain |

## File Naming Conventions

Chezmoi uses special prefixes to control file behavior:

| Prefix | Meaning | Example |
|--------|---------|---------|
| `dot_` | Creates dotfile (prefixes with `.`) | `dot_zshrc` → `.zshrc` |
| `private_` | Sets 0600 permissions | `private_dot_ssh/` |
| `run_once_` | Script runs once ever | `run_once_after_01-install-ohmyzsh.sh.tmpl` |
| `run_onchange_` | Script runs when content changes | `run_onchange_before_install-packages-darwin.sh.tmpl` |
| `before_` | Runs before file application | `run_once_before_00-setup-directories.sh` |
| `after_` | Runs after file application | `run_once_after_01-install-ohmyzsh.sh.tmpl` |
| `.tmpl` | File is a Go template | `dot_gitconfig.tmpl` |

### Execution Order

Scripts execute in this order:
1. `run_once_before_*` and `run_onchange_before_*` (alphabetically)
2. File application
3. `run_once_after_*` and `run_onchange_after_*` (alphabetically)

Numbers in filenames (e.g., `00-`, `01-`) control alphabetical ordering.

## Shell Configuration Load Order

When you open a terminal, zsh loads configuration in this order:

```
┌─────────────────────────────────────────────────────────────────────────────┐
│  1. ~/.zshenv (all shells)                                                  │
│     • Basic environment variables                                           │
│     • EDITOR, HISTSIZE, XDG paths                                           │
└─────────────────────────────────────────────────────────────────────────────┘
                                      │
                                      ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│  2. ~/.zprofile (login shells only)                                         │
│     • Homebrew initialization                                               │
│     • Docker socket setup                                                   │
│     • Source ~/.env if exists                                               │
└─────────────────────────────────────────────────────────────────────────────┘
                                      │
                                      ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│  3. ~/.zshrc (interactive shells)                                           │
│     • Powerlevel10k instant prompt                                          │
│     • Oh My Zsh initialization                                              │
│     • Source conf.d/*.zsh modules                                           │
│     • Source ~/.aliases.zsh                                                 │
│     • Source ~/.p10k.zsh                                                    │
└─────────────────────────────────────────────────────────────────────────────┘
                                      │
                                      ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│  4. ~/.config/zsh/conf.d/*.zsh (loaded by .zshrc)                           │
│     • 00-path.zsh   - PATH management                                       │
│     • 10-tools.zsh  - Tool initialization (asdf, nvm, atuin, etc.)          │
│     • 20-completions.zsh - Shell completions (kubectl, gh, gt)              │
└─────────────────────────────────────────────────────────────────────────────┘
```

## Component Dependencies

```
                    ┌─────────────────┐
                    │    chezmoi      │
                    │  (core engine)  │
                    └────────┬────────┘
                             │
            ┌────────────────┼────────────────┐
            │                │                │
            ▼                ▼                ▼
     ┌──────────┐     ┌──────────┐     ┌──────────┐
     │   git    │     │  curl    │     │  make    │
     │          │     │          │     │(optional)│
     └──────────┘     └──────────┘     └──────────┘

                    After First Apply:

     ┌─────────────────────────────────────────────────┐
     │                   Homebrew                       │
     │                      │                           │
     │    ┌─────────────────┼─────────────────┐        │
     │    │                 │                 │        │
     │    ▼                 ▼                 ▼        │
     │ ┌──────┐      ┌───────────┐     ┌──────────┐   │
     │ │ node │      │Development│     │   CLI    │   │
     │ │      │      │  Tools    │     │  Tools   │   │
     │ └──┬───┘      └───────────┘     └──────────┘   │
     │    │                                            │
     │    ▼                                            │
     │ ┌──────────────┐                                │
     │ │ npm globals  │                                │
     │ │ (claude-code,│                                │
     │ │  aws-cdk,..) │                                │
     │ └──────────────┘                                │
     └─────────────────────────────────────────────────┘

     ┌─────────────────────────────────────────────────┐
     │                   Oh My Zsh                      │
     │                      │                           │
     │                      ▼                           │
     │              ┌──────────────┐                    │
     │              │ Powerlevel10k│                    │
     │              └──────────────┘                    │
     └─────────────────────────────────────────────────┘
```

## Directory Structure

After full application, your home directory will have:

```
~/
├── .config/
│   ├── chezmoi/          # Chezmoi configuration
│   │   └── chezmoi.toml  # Generated from .chezmoi.toml.tmpl
│   ├── nvim/             # Neovim configuration
│   ├── zsh/
│   │   └── conf.d/       # Modular zsh configs
│   ├── kitty/            # Kitty terminal
│   ├── atuin/            # Shell history sync
│   └── gh/               # GitHub CLI
├── .local/
│   ├── bin/              # User binaries
│   ├── share/
│   │   └── chezmoi/      # Dotfiles source repository
│   └── state/
│       └── zsh/          # Zsh state files
├── .oh-my-zsh/           # Oh My Zsh installation
├── .ssh/                 # SSH keys (generated)
├── Projects/             # Project directory
├── git/                  # Git repositories
├── .zshrc                # Main shell config
├── .zprofile             # Login shell config
├── .zshenv               # Environment variables
├── .gitconfig            # Git configuration
├── .tmux.conf            # Tmux configuration
├── .aliases.zsh          # Shared aliases
└── .p10k.zsh             # Powerlevel10k theme
```

## State Management

Chezmoi tracks what has been applied:

| Location | Purpose |
|----------|---------|
| `~/.local/share/chezmoi/` | Source repository (your dotfiles) |
| `~/.config/chezmoi/chezmoi.toml` | Generated configuration with template data |
| `~/.local/share/chezmoi/.chezmoistate.boltdb` | Script execution state (which `run_once_` scripts have run) |

### Re-running Scripts

- **`run_once_*`**: Never re-run unless you clear state
- **`run_onchange_*`**: Re-run when script content changes (via hash)

To force re-run of `run_once_*` scripts:
```bash
chezmoi state delete-bucket --bucket=scriptState
chezmoi apply
```

## Conditional Logic

Templates use Go template syntax for conditional behavior:

```go
// OS-specific
{{ if .machine.isDarwin }}
# macOS only
{{ end }}

{{ if .machine.isLinux }}
# Linux only
{{ end }}

// Machine type
{{ if .machine.isWork }}
# Work machine only
{{ end }}

// GUI detection
{{ if .machine.hasGui }}
# Only install if GUI available
{{ end }}
```

## Testing Architecture

See [testing/README.md](../testing/README.md) for the full testing documentation.

```
testing/
├── docker-compose.yml    # Linux test containers (Arch)
├── Dockerfile            # Ansible control node
├── playbooks/
│   └── test-dotfiles.yml # Main test playbook
├── inventories/
│   └── hosts.yml         # Test targets
└── macos/
    └── README.md         # macOS VM testing (Tart/Lima)
```

## Related Documentation

- [TEMPLATES.md](TEMPLATES.md) - Template syntax and variables
- [PROFILES.md](PROFILES.md) - Work vs personal profiles
- [SCRIPTS.md](SCRIPTS.md) - Detailed script documentation
- [SHELL.md](SHELL.md) - Shell configuration details
