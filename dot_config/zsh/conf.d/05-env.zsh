# History — re-asserted here (after `source $ZSH/oh-my-zsh.sh` in .zshrc) because
# Oh My Zsh's history lib sets HISTFILE=$HOME/.zsh_history and would otherwise win
# over the value exported in ~/.zshenv.
export HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
export HISTSIZE=100000
export SAVEHIST=100000

# Load non-secret environment variables from ~/.env (managed by chezmoi).
# This is the line that was missing — ~/.env was generated but never sourced.
[[ -f "$HOME/.env" ]] && source "$HOME/.env"
