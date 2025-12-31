# Shell Configuration

## Overview

Modular zsh setup using Oh My Zsh + Powerlevel10k.

## Structure

```
~/.config/zsh/
├── .zshenv           # Loaded first (all shells)
├── .zprofile         # Login shells only
└── conf.d/           # Modular configs
    ├── 00-path.zsh   # PATH management
    ├── 10-tools.zsh  # Tool initialization
    └── 20-completions.zsh  # Completions
```

## Load Order

1. `.zshenv` - Environment variables
2. `.zprofile` - Login setup (Homebrew, .env)
3. `.zshrc` - Interactive shell (Oh My Zsh, modules)
4. `conf.d/*.zsh` - Additional configs

## Key Settings

### Environment (.zshenv)

```bash
export EDITOR="nvim"        # Default editor
export HISTSIZE=100000      # Large history
```

### Path Management (00-path.zsh)

Ensures unique path entries, prioritizes:
1. `~/.local/bin` - User binaries
2. Homebrew (macOS)
3. Language-specific (Cargo, Perl)

### Tools (10-tools.zsh)

Initializes in order:
1. asdf - Version manager
2. nvm - Node versions
3. atuin - Shell history
4. zoxide - Smart cd
5. fzf - Fuzzy finder
6. direnv - Directory environments

### Completions (20-completions.zsh)

Auto-completes for:
- kubectl
- gh (GitHub CLI)
- gt (Graphite)

## Customization

Add files to `~/.config/zsh/conf.d/` with numeric prefixes for load order.
