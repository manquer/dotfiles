# Package Management

Complete list of packages, tools, and applications installed by this dotfiles setup.

## Overview

| Platform | Method | Count |
|----------|--------|-------|
| macOS | Homebrew | 108 formulas |
| macOS | Homebrew Casks | 20 apps |
| macOS | npm | 18 globals |
| Linux | pacman/apt/dnf | Core tools |

## macOS Packages (Homebrew)

### Version Control

| Package | Description |
|---------|-------------|
| `git` | Version control |
| `gh` | GitHub CLI |
| `git-lfs` | Large File Storage |
| `git-delta` | Better diff viewer |
| `git-extras` | Advanced git commands |
| `git-filter-repo` | History rewriting |
| `git-crypt` | File encryption |
| `graphite` | Modern Git workflow |

### Shell & Terminal

| Package | Description |
|---------|-------------|
| `zsh` | Z shell |
| `bash` | Bourne-Again shell |
| `fish` | Friendly interactive shell |
| `tmux` | Terminal multiplexer |
| `zellij` | Modern terminal multiplexer |
| `starship` | Cross-shell prompt |
| `atuin` | Shell history sync |

### Development Languages & Runtimes

| Package | Description |
|---------|-------------|
| `asdf` | Multi-language version manager |
| `node` | JavaScript runtime |
| `deno` | Modern JS/TS runtime |
| `python@3.12` | Python 3.12 |
| `go` | Go language |
| `rust` | Rust language |
| `ruby` | Ruby language |
| `php` | PHP language |
| `composer` | PHP package manager |
| `elixir` | Elixir language |
| `lua` | Lua scripting |
| `openjdk` | Java Development Kit |

### Editors

| Package | Description |
|---------|-------------|
| `neovim` | Modern Vim |
| `vim` | Vi IMproved |
| `helix` | Modern modal editor |

### CLI Utilities

| Package | Description |
|---------|-------------|
| `jq` | JSON processor |
| `yq` | YAML processor |
| `tree` | Directory viewer |
| `ripgrep` | Fast grep (`rg`) |
| `fd` | Fast find |
| `bat` | Better cat |
| `eza` | Modern ls |
| `fzf` | Fuzzy finder |
| `tldr` | Simplified man pages |
| `direnv` | Per-directory env |
| `zoxide` | Smarter cd |
| `watchman` | File watcher |
| `ctags` | Code navigation |
| `the_silver_searcher` | Code search (`ag`) |
| `graphviz` | Graph visualization |

### DevOps & Cloud

| Package | Description |
|---------|-------------|
| `docker` | Container runtime |
| `colima` | Container runtime for macOS |
| `podman` | Alternative containers |
| `podman-compose` | Compose for Podman |
| `kubectl` | Kubernetes CLI |
| `helm` | Kubernetes packages |
| `argocd` | GitOps CD |
| `terraform` | Infrastructure as Code |
| `ansible` | Configuration management |
| `awscli` | AWS CLI |
| `aws-sam-cli` | AWS Serverless |
| `azure-cli` | Azure CLI |
| `azcopy` | Azure data transfer |
| `azd` | Azure Developer CLI |
| `kubelogin` | K8s Azure AD auth |
| `doctl` | DigitalOcean CLI |
| `temporal` | Workflow orchestration |
| `tcld` | Temporal Cloud CLI |
| `crane` | Container registry tool |
| `skopeo` | Container images |
| `buildkit` | Modern build engine |
| `rover` | Apollo GraphQL CLI |

### System Utilities

| Package | Description |
|---------|-------------|
| `wget` | Network downloader |
| `curl` | URL transfer |
| `htop` | Process viewer |
| `btop` | Better resource monitor |
| `ncdu` | Disk usage analyzer |
| `watch` | Execute periodically |
| `gnupg` | GPG encryption |
| `openssh` | SSH client/server |
| `chezmoi` | Dotfiles manager |
| `moreutils` | Unix utilities |
| `parallel` | Parallel execution |

### Development Utilities

| Package | Description |
|---------|-------------|
| `httpie` | HTTP client |
| `posting` | HTTP client TUI |
| `glow` | Markdown renderer |
| `slides` | Terminal presentations |
| `presenterm` | Terminal presentations |
| `mosh` | Mobile shell |
| `shellcheck` | Shell linter |
| `bats-core` | Bash testing |
| `vale` | Prose linter |
| `cloc` | Count lines of code |
| `yamllint` | YAML linter |

### Networking & Debug

| Package | Description |
|---------|-------------|
| `speedtest-cli` | Internet speed test |
| `gping` | Ping with graph |
| `iftop` | Bandwidth monitor |
| `lynx` | Text web browser |
| `telnet` | Debug connections |

### Misc Tools

| Package | Description |
|---------|-------------|
| `asciinema` | Terminal recorder |
| `redis` | In-memory database |
| `uv` | Fast Python packages |
| `sentry-cli` | Sentry CLI |
| `task` | Task management |
| `timewarrior` | Time tracking |
| `terminal-notifier` | macOS notifications |
| `blueutil` | Bluetooth CLI |
| `jwt-cli` | JWT tool |
| `ascii-image-converter` | ASCII art |
| `yt-dlp` | Video downloader |
| `zx` | JS shell scripting |
| `qodana` | Code quality CLI |
| `mas` | Mac App Store CLI |

## GUI Applications (Casks)

Only installed when GUI is detected (`.machine.hasGui = true`).

### Development

| App | Description |
|-----|-------------|
| iTerm2 | Terminal emulator |
| Postman | API client |
| TablePlus | Database GUI |

### Browsers

| App | Description |
|-----|-------------|
| Google Chrome | Web browser |
| Firefox | Web browser |

### Communication

| App | Description |
|-----|-------------|
| Slack | Team messaging |
| Discord | Chat platform |
| Zoom | Video conferencing |

### Productivity

| App | Description |
|-----|-------------|
| Notion | Notes & docs |
| Obsidian | Markdown notes |
| Rectangle | Window manager |
| Raycast | Spotlight alternative |
| Caffeine | Prevent sleep |

### Utilities

| App | Description |
|-----|-------------|
| The Unarchiver | Archive extraction |
| AppCleaner | App removal |
| KeepingYouAwake | Prevent sleep |
| Stats | System monitor |

## Fonts (Nerd Fonts)

| Font | Description |
|------|-------------|
| Fira Code Nerd Font | Monospace with ligatures |
| JetBrains Mono Nerd Font | JetBrains IDE font |
| Hack Nerd Font | Designed for code |

All include Nerd Font icons for terminal/editor use.

## npm Global Packages

| Package | Description |
|---------|-------------|
| `@anthropic-ai/claude-code` | Claude Code CLI |
| `@openai/codex` | OpenAI Codex CLI |
| `@devcontainers/cli` | Dev Container CLI |
| `@mermaid-js/mermaid-cli` | Diagram generation |
| `@usebruno/cli` | API testing |
| `@northflank/cli` | Northflank platform |
| `aws-cdk` | AWS CDK CLI |
| `concurrently` | Run multiple commands |
| `dotenv-cli` | Load env files |
| `esbuild` | Fast JS bundler |
| `fast-cli` | Netflix speed test |
| `graphql-cli` | GraphQL tools |
| `jest` | JavaScript testing |
| `neonctl` | Neon database CLI |
| `nx` | Monorepo build system |
| `terminalizer` | Terminal recording |
| `ts-node` | TypeScript execution |
| `tsx` | TypeScript execute |
| `typescript` | TypeScript compiler |
| `webpack-cli` | Webpack CLI |

## Linux Packages

Script: `run_onchange_before_install-packages-linux.sh.tmpl`

### Arch Linux (pacman)

Core packages equivalent to macOS setup:

```bash
pacman -S git neovim zsh tmux ripgrep fd bat eza fzf jq yq \
    docker kubectl helm terraform ansible nodejs npm python go rust
```

### Ubuntu/Debian (apt)

```bash
apt install git neovim zsh tmux ripgrep fd-find bat exa fzf jq \
    docker.io kubectl nodejs npm python3 golang
```

### Fedora (dnf)

```bash
dnf install git neovim zsh tmux ripgrep fd-find bat eza fzf jq yq \
    podman kubectl helm terraform ansible nodejs npm python3 golang rust
```

## Installation Trigger

Packages are installed by `run_onchange_before_install-packages-*.sh.tmpl`:

- **First run**: All packages installed
- **Changes to list**: Reinstall triggered (via content hash)

## Adding New Packages

### Homebrew Formula/Cask

Edit `run_onchange_before_install-packages-darwin.sh.tmpl`:

```bash
# CLI tool
brew "new-package"

# GUI app (conditional)
{{ if .machine.hasGui }}
cask "new-app"
{{ end }}
```

### npm Global

Add to the npm install list:

```bash
npm install -g \
    existing-packages \
    new-package
```

### Apply Changes

```bash
chezmoi apply
```

Since the script is `run_onchange_`, it will re-run when content changes.

## Profile-Specific Packages

Some packages are profile-conditional:

```bash
{{ if .machine.isWork }}
# Work-only packages
brew "work-specific-tool"
{{ end }}
```

Currently, `@openai/codex` is installed on all profiles but can be restricted.

## Related Documentation

- [SCRIPTS.md](SCRIPTS.md) - How package scripts work
- [PROFILES.md](PROFILES.md) - Work vs personal profiles
- [SETUP.md](SETUP.md) - Installation guide
