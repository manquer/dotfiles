# Package Management

## macOS (Homebrew)

Script: `run_onchange_before_install-packages-darwin.sh.tmpl`

### CLI Tools

**Version Control**
- git, gh, git-lfs, git-delta, graphite

**Shell**
- zsh, bash, fish, tmux, zellij, starship, atuin

**Development**
- asdf, neovim, vim, helix
- node, python@3.12, go, rust
- jq, yq, ripgrep, fd, bat, eza, fzf

**DevOps**
- docker, colima, podman, kubectl, helm
- terraform, ansible
- awscli, azure-cli, doctl
- temporal

**Utilities**
- httpie, glow, mosh, shellcheck, vale
- cloc, speedtest-cli, asciinema
- redis, uv, sentry-cli, task, timewarrior
- terminal-notifier

### GUI Apps (if GUI detected)

- iTerm2, Postman, TablePlus
- Chrome, Firefox
- Slack, Discord, Zoom
- Notion, Obsidian, Rectangle, Raycast

### Fonts

- Fira Code Nerd Font
- JetBrains Mono Nerd Font
- Hack Nerd Font

### npm Globals

- @anthropic-ai/claude-code
- @openai/codex (work profile only)
- @devcontainers/cli
- @mermaid-js/mermaid-cli
- @usebruno/cli, @northflank/cli
- aws-cdk, nx, jest
- ts-node, tsx, typescript

## Linux (Arch)

Script: `run_onchange_before_install-packages-linux.sh.tmpl`

Uses `pacman` for package installation. Installs similar tools to macOS.

GUI apps installed only if X11/Wayland detected.

## Updates

Changes to package lists trigger reinstall via `run_onchange_` prefix.
