# Shell Configuration

Modular zsh setup using Oh My Zsh and Powerlevel10k, with organized configuration files for paths, tools, completions, and aliases.

## Overview

| Component | Purpose |
|-----------|---------|
| **Oh My Zsh** | Plugin framework |
| **Powerlevel10k** | Theme with instant prompt |
| **conf.d/** | Modular configuration |
| **aliases.zsh** | Command shortcuts |

## Directory Structure

```
~/
├── .zshenv                 # Environment variables (all shells)
├── .zprofile               # Login shell setup
├── .zshrc                  # Interactive shell config
├── .p10k.zsh               # Powerlevel10k theme
├── .aliases.zsh            # Shared aliases
└── .config/zsh/
    └── conf.d/
        ├── 00-path.zsh     # PATH management
        ├── 10-tools.zsh    # Tool initialization
        └── 20-completions.zsh  # Shell completions
```

## Load Order

```
1. ~/.zshenv           # Always loaded first (all shells)
       │
       ▼
2. ~/.zprofile         # Login shells only
       │               # - Homebrew setup
       │               # - Docker socket
       ▼
3. ~/.zshrc            # Interactive shells
       │               # - Powerlevel10k instant prompt
       │               # - Oh My Zsh initialization
       │               # - Load conf.d/*.zsh
       │               # - Load .aliases.zsh
       │               # - Load .p10k.zsh
       ▼
4. conf.d/*.zsh        # Modular configs (numerical order)
   ├── 00-path.zsh     # PATH setup
   ├── 10-tools.zsh    # Tool init (asdf, nvm, atuin, etc.)
   └── 20-completions.zsh  # Completions (kubectl, gh, gt)
```

## Configuration Files

### `.zshenv` - Environment Variables

Loaded by all zsh instances (scripts, interactive, login):

```zsh
export EDITOR="nvim"
export HISTSIZE=100000
```

### `.zprofile` - Login Shell Setup

```zsh
# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Docker socket (Colima)
export DOCKER_HOST="unix://$HOME/.colima/docker.sock"

# JetBrains Toolbox
export PATH="$PATH:$HOME/Library/Application Support/JetBrains/Toolbox/scripts"
```

### `.zshrc` - Interactive Shell

Main shell configuration:

```zsh
# Instant prompt (must be at very top)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git)
source $ZSH/oh-my-zsh.sh

# Load modular configs
for config_file in "${ZSH_CONFIG_DIR}"/conf.d/*.zsh(N); do
    source "$config_file"
done

# Aliases and theme
source ~/.aliases.zsh
source ~/.p10k.zsh
```

### `00-path.zsh` - PATH Management

Ensures unique PATH entries and proper ordering:

```zsh
typeset -U path  # Unique entries only

# Local binaries (highest priority)
path=("${HOME}/.local/bin" $path)

# macOS: Homebrew paths
path=(
    /opt/homebrew/bin
    /opt/homebrew/sbin
    /opt/homebrew/opt/curl/bin
    /usr/local/opt/libpq/bin
    $path
)

# Rust/Cargo
if [[ -d "${HOME}/.cargo/bin" ]]; then
    path=("${HOME}/.cargo/bin" $path)
fi

# Perl (if installed)
if [[ -d "${HOME}/perl5/bin" ]]; then
    path=("${HOME}/perl5/bin" $path)
    export PERL5LIB="${HOME}/perl5/lib/perl5"
fi

# Work-specific paths
{{ if .machine.isWork }}
path=("$HOME/Library/Application Support/JetBrains/Toolbox/scripts" $path)
{{ end }}
```

### `10-tools.zsh` - Tool Initialization

Initializes development tools in correct order:

```zsh
# asdf (version manager)
export ASDF_DATA_DIR="${HOME}/.asdf"
path=("${ASDF_DATA_DIR}/shims" $path)

# nvm (Node versions)
export NVM_DIR="${HOME}/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# atuin (shell history)
eval "$(atuin init zsh)"

# zoxide (smart cd)
eval "$(zoxide init zsh)"

# fzf (fuzzy finder)
source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
source /opt/homebrew/opt/fzf/shell/completion.zsh

# direnv (directory environments)
eval "$(direnv hook zsh)"
```

### `20-completions.zsh` - Shell Completions

```zsh
# Initialize completion system
autoload -Uz compinit

# Load completions once a day (performance optimization)
if [[ -n ${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump(#qN.mh+24) ]]; then
    compinit -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"
else
    compinit -C -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"
fi

# Tool completions
source <(kubectl completion zsh)    # Kubernetes
eval "$(gh completion -s zsh)"      # GitHub CLI
compdef _gt_yargs_completions gt    # Graphite
```

## Aliases

### Modern CLI Replacements

| Alias | Command | Tool |
|-------|---------|------|
| `ls` | `eza --icons --group-directories-first` | eza |
| `ll` | `eza -l --icons` | eza |
| `la` | `eza -la --icons` | eza |
| `lt` | `eza --tree --level=2 --icons` | eza |
| `cat` | `bat --style=auto` | bat |
| `lg` | `lazygit` | lazygit |
| `ld` | `lazydocker` | lazydocker |
| `help` | `tldr` | tldr |
| `cd` | `z` | zoxide |

### Git Aliases

| Alias | Command |
|-------|---------|
| `gst` | `git status` |
| `gco` | `git checkout` |
| `gcb` | `git checkout -b` |
| `gp` | `git push` |
| `gP` | `git pull` |
| `glog` | `git log --oneline --graph --decorate` |
| `gdiff` | `git diff` |
| `gadd` | `git add` |
| `gcom` | `git commit` |
| `gbr` | `git branch` |

### Docker Aliases

| Alias | Command |
|-------|---------|
| `dps` | `docker ps` |
| `dpsa` | `docker ps -a` |
| `dim` | `docker images` |
| `dex` | `docker exec -it` |
| `dlogs` | `docker logs -f` |

### Nx (Monorepo) Aliases

| Alias | Command |
|-------|---------|
| `nxb` | `nx run-many --target=build --all` |
| `nxt` | `nx run-many --target=test --all` |
| `nxl` | `nx run-many --target=lint --all` |
| `nxf` | `nx format:write --all` |
| `nxc` | `nx reset` |

### Sentry CLI Aliases

| Alias | Command |
|-------|---------|
| `si` | `sentry-cli issues list` |
| `sil` | `sentry-cli issues list --limit 20` |
| `sinfo` | `sentry-cli info` |
| `spl` | `sentry-cli projects list` |

### Northflank Aliases

| Alias | Command |
|-------|---------|
| `nfpl` | `northflank project list` |
| `nfsl` | `northflank service list` |
| `nfbl` | `northflank build list` |

## fzf Configuration

```zsh
# UI settings
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --inline-info'

# Use fd for file finding (respects .gitignore)
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
```

## Oh My Zsh

### Enabled Plugins

```zsh
plugins=(git)
```

The `git` plugin provides:
- Git aliases (`g`, `gst`, `gco`, etc.)
- Git prompt information
- Branch completion

### Theme

Powerlevel10k with instant prompt for fast shell startup:

```zsh
ZSH_THEME="powerlevel10k/powerlevel10k"
```

Configure theme interactively:
```bash
p10k configure
```

## Adding Custom Configuration

### Method 1: conf.d Module

Create numbered file in `~/.config/zsh/conf.d/`:

```bash
# Create new module
chezmoi edit ~/.config/zsh/conf.d/30-myconfig.zsh
```

```zsh
# 30-myconfig.zsh
export MY_VAR="value"
alias myalias='some-command'
```

### Method 2: Edit Aliases

```bash
chezmoi edit ~/.aliases.zsh
```

### Method 3: Machine-Specific

Use templates in `.zshrc.tmpl`:

```zsh
{{ if .machine.isWork }}
# Work-specific shell config
{{ end }}

{{ if .machine.isDarwin }}
# macOS-specific config
{{ end }}
```

## Troubleshooting

### Slow Shell Startup

1. Profile startup time:
   ```bash
   time zsh -i -c exit
   ```

2. Check plugin load times:
   ```bash
   zprof  # Add 'zmodload zsh/zprof' at top of .zshrc
   ```

3. Ensure completions cache is working:
   ```bash
   ls -la ~/.cache/zsh/zcompdump
   ```

### Completion Not Working

```bash
# Rebuild completions
rm -f ~/.cache/zsh/zcompdump*
compinit
```

### PATH Issues

```bash
# Check PATH order
echo $PATH | tr ':' '\n'

# Check for duplicates
echo $PATH | tr ':' '\n' | sort | uniq -d
```

## Related Documentation

- [TOOLS.md](TOOLS.md) - Tool configurations (atuin, fzf, zoxide)
- [ARCHITECTURE.md](ARCHITECTURE.md) - Shell load order in system context
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k) - Theme documentation
- [Oh My Zsh](https://ohmyz.sh/) - Framework documentation
