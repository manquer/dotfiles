# Tool Configurations

This document covers the configuration of various development tools included in this dotfiles setup.

## Tool Initialization

Tools are initialized in `~/.config/zsh/conf.d/10-tools.zsh` in this order:

1. asdf (version manager)
2. nvm (Node versions)
3. atuin (shell history)
4. zoxide (smart cd)
5. fzf (fuzzy finder)
6. direnv (directory environments)

## Atuin

Atuin provides shell history sync across machines with encryption.

### Configuration File

`~/.config/atuin/config.toml`

### Key Settings

```toml
# Search across all hosts (global history)
filter_mode = "global"

# Compact UI style
style = "compact"

# Show 30 lines of history
inline_height = 30

# Search bar at top
invert = true

# Show full command preview
show_preview = true

# Execute on Enter, edit on Tab
enter_accept = true
```

### Usage

| Key | Action |
|-----|--------|
| `Ctrl+R` | Search history |
| `Up Arrow` | Previous command (context-aware) |
| `Enter` | Execute selected command |
| `Tab` | Edit selected command |

### Sync Setup

```bash
# Register account
atuin register

# Login
atuin login

# Manual sync
atuin sync
```

## GitHub CLI (gh)

### Configuration

`~/.config/gh/config.yml` (private)

### gh-dash

Dashboard extension for PRs and issues.

**Configuration**: `~/.config/gh-dash/config.yml`

```yaml
prSections:
  - title: My Pull Requests
    filters: is:open author:@me
  - title: Needs My Review
    filters: is:open review-requested:@me
  - title: Involved
    filters: is:open involves:@me -author:@me

issuesSections:
  - title: My Issues
    filters: is:open author:@me
  - title: Assigned
    filters: is:open assignee:@me

defaults:
  preview:
    open: true
    width: 50
  prsLimit: 20
  view: prs
```

### Usage

```bash
# Open dashboard
gh dash

# Standard gh commands
gh pr list
gh pr create
gh issue list
```

## Tmux

Terminal multiplexer configuration.

### Configuration File

`~/.tmux.conf`

### Key Settings

```bash
# Prefix key: ` (backtick)
unbind C-b
set -g prefix `
bind-key ` send-prefix

# Large history
set-option -g history-limit 400000

# 256 color support
set -g default-terminal "xterm-256color"

# Use Homebrew zsh
set-option -g default-shell /opt/homebrew/bin/zsh
```

### Key Bindings

| Key | Action |
|-----|--------|
| `` ` `` | Prefix key |
| `` ` + c`` | New window |
| `` ` + n`` | Next window |
| `` ` + p`` | Previous window |
| `` ` + %`` | Vertical split |
| `` ` + "`` | Horizontal split |
| `` ` + d`` | Detach |

## Kitty Terminal

Modern GPU-accelerated terminal.

### Configuration File

`~/.config/kitty/kitty.conf`

### Key Settings

```conf
# Font size
font_size 25.0
```

### Features

- GPU rendering
- Ligature support
- Image display
- Tabs and splits
- Remote control

### Usage

```bash
# Open new tab
Cmd+T

# Split vertically
Cmd+Enter

# Configure fonts interactively
kitten choose-fonts
```

## zoxide

Smarter cd command that learns from your navigation patterns.

### Initialization

```zsh
# In 10-tools.zsh
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init zsh)"
fi
```

### Usage

```bash
# Jump to directory (fuzzy match)
z projects

# Jump to specific path
z ~/Projects/myproject

# Interactive selection
zi

# Show frecency list
zoxide query -ls
```

## fzf

Fuzzy finder for files, history, and more.

### Initialization

```zsh
# macOS
source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
source /opt/homebrew/opt/fzf/shell/completion.zsh

# Linux
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh
```

### Key Bindings

| Key | Action |
|-----|--------|
| `Ctrl+T` | Find files |
| `Ctrl+R` | Search history (overridden by Atuin) |
| `Alt+C` | Change directory |

### Usage

```bash
# Pipe to fzf
cat file.txt | fzf

# Find files
fzf

# Preview files
fzf --preview 'cat {}'

# With fd
fd | fzf
```

## direnv

Automatic environment loading per directory.

### Initialization

```zsh
if command -v direnv &>/dev/null; then
    eval "$(direnv hook zsh)"
fi
```

### Usage

Create `.envrc` in project directory:

```bash
# Simple export
export MY_VAR=value

# Load .env file
dotenv

# Use specific Node version
use node 18

# Use asdf
use asdf
```

Allow the envrc:

```bash
direnv allow
```

## asdf

Universal version manager for multiple languages.

### Initialization

```zsh
if [[ -d "${ASDF_DATA_DIR:-$HOME/.asdf}" ]]; then
    export ASDF_DATA_DIR="${ASDF_DATA_DIR:-$HOME/.asdf}"
    path=("${ASDF_DATA_DIR}/shims" $path)
    fpath=("${ASDF_DATA_DIR}/completions" $fpath)
fi
```

### Usage

```bash
# Add plugin
asdf plugin add nodejs

# Install version
asdf install nodejs 20.0.0

# Set global version
asdf global nodejs 20.0.0

# Set local version (project-specific)
asdf local nodejs 20.0.0

# List installed
asdf list nodejs
```

## nvm

Node Version Manager (used alongside asdf).

### Initialization

```zsh
if [[ -d "${HOME}/.nvm" ]]; then
    export NVM_DIR="${HOME}/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
fi
```

### Usage

```bash
# Install Node version
nvm install 20

# Use version
nvm use 20

# Set default
nvm alias default 20

# List versions
nvm ls
```

## Tool Comparison

| Tool | Purpose | Alternative |
|------|---------|-------------|
| Atuin | Shell history | ctrl-r, hstr |
| zoxide | Directory jumping | z, autojump |
| fzf | Fuzzy finding | skim |
| direnv | Env per directory | autoenv |
| asdf | Version management | mise, nvm, pyenv |
| Kitty | Terminal | iTerm2, Alacritty |
| Tmux | Multiplexer | Zellij, screen |

## Adding New Tools

1. Add to package list in `run_onchange_before_install-packages-*.sh.tmpl`

2. Add initialization to `dot_config/zsh/conf.d/10-tools.zsh.tmpl`:

```zsh
# New tool
if command -v newtool &>/dev/null; then
    eval "$(newtool init zsh)"
fi
```

3. Add configuration file if needed:

```bash
# Add to chezmoi
chezmoi add ~/.config/newtool/config.toml
```

## Related Documentation

- [SHELL.md](SHELL.md) - Shell configuration
- [PACKAGES.md](PACKAGES.md) - Package installation
- [NEOVIM.md](NEOVIM.md) - Editor configuration
