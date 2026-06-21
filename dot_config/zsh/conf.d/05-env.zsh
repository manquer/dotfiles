# Load non-secret environment variables from ~/.env (managed by chezmoi).
# This is the line that was missing — ~/.env was generated but never sourced.
[[ -f "$HOME/.env" ]] && source "$HOME/.env"
