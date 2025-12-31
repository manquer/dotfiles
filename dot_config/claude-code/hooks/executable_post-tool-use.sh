#!/bin/bash
# Post tool use hook - sends notification after tool execution

TOOL_NAME="${1:-unknown}"
EXIT_CODE="${2:-0}"

if command -v terminal-notifier &>/dev/null; then
    if [ "$EXIT_CODE" -eq 0 ]; then
        terminal-notifier \
            -title "Claude Code" \
            -message "Tool '$TOOL_NAME' completed successfully" \
            -sound default
    else
        terminal-notifier \
            -title "Claude Code" \
            -message "Tool '$TOOL_NAME' failed with code $EXIT_CODE" \
            -sound Basso
    fi
fi
