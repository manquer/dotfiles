#!/bin/bash
set -euo pipefail

echo "Creating standard directories..."

mkdir -p "${HOME}"/{Projects,git,Downloads,Documents}
mkdir -p "${HOME}/.config"
mkdir -p "${HOME}/.local"/{bin,share,state}
mkdir -p "${HOME}/.cache/zsh"
mkdir -p "${HOME}/.local/state/zsh"

echo "Directories created successfully."
