# Productivity Tools Aliases
# This file is copied to ~/.aliases.zsh and sourced in ~/.zshrc
# To update: cp ~/git/talview/apis/dev/.devcontainer/.aliases.zsh ~/.aliases.zsh && source ~/.zshrc

# Initialize zoxide (smarter cd) if available
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"
fi

# Initialize fzf (fuzzy finder) if available
if [ -f /usr/local/share/fzf/shell/key-bindings.zsh ]; then
    source /usr/local/share/fzf/shell/key-bindings.zsh
    source /usr/local/share/fzf/shell/completion.zsh
fi

# fzf configuration
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --inline-info'
if command -v fd &> /dev/null; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
fi

# Modern CLI replacements (only if tools are installed)
if command -v eza &> /dev/null; then
    alias ls='eza --icons --group-directories-first'
    alias ll='eza -l --icons --group-directories-first'
    alias la='eza -la --icons --group-directories-first'
    alias lt='eza --tree --level=2 --icons'
fi

if command -v bat &> /dev/null; then
    alias cat='bat --style=auto'
fi

if command -v lazygit &> /dev/null; then
    alias lg='lazygit'
fi

if command -v lazydocker &> /dev/null; then
    alias ld='lazydocker'
fi

if command -v tldr &> /dev/null; then
    alias help='tldr'
fi

# Git aliases for common operations
alias gst='git status'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gp='git push'
alias gP='git pull'
alias glog='git log --oneline --graph --decorate'
alias gdiff='git diff'
alias gadd='git add'
alias gcom='git commit'
alias gbr='git branch'

# Quick directory navigation with zoxide
if command -v zoxide &> /dev/null; then
    alias cd='z'
fi

# Docker aliases
alias dps='docker ps'
alias dpsa='docker ps -a'
alias dim='docker images'
alias dex='docker exec -it'
alias dlogs='docker logs -f'

# Nx aliases for monorepo
alias nxb='nx run-many --target=build --all'
alias nxt='nx run-many --target=test --all'
alias nxl='nx run-many --target=lint --all'
alias nxf='nx format:write --all'
alias nxc='nx reset'

# Sentry CLI aliases
if command -v sentry-cli &> /dev/null; then
    alias si='sentry-cli issues list'
    alias sil='sentry-cli issues list --limit 20'
    alias sinfo='sentry-cli info'
    alias spl='sentry-cli projects list'
fi

# Northflank CLI aliases
if command -v northflank &> /dev/null; then
    alias nfpl='northflank project list'
    alias nfsl='northflank service list'
    alias nfbl='northflank build list'
fi
