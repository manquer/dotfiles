# Scripts

Chezmoi supports running scripts as part of the dotfiles application process. Scripts automate setup tasks like installing packages, configuring tools, and generating keys.

## Script Types

| Type | Prefix | Runs When |
|------|--------|-----------|
| **run_once** | `run_once_` | First time only (state tracked) |
| **run_onchange** | `run_onchange_` | When script content changes (hash-based) |

## Execution Order

Scripts run in this order:

1. `run_once_before_*` (alphabetically)
2. `run_onchange_before_*` (alphabetically)
3. **File application**
4. `run_once_after_*` (alphabetically)
5. `run_onchange_after_*` (alphabetically)

Numbers in filenames (e.g., `00-`, `01-`) control sort order within each phase.

## Scripts in This Repository

### Before Scripts

#### `run_once_before_00-setup-directories.sh`

**Purpose**: Creates standard directory structure before any files are applied.

**Runs**: Once, before files

**Creates**:
```
~/Projects/          # Project workspace
~/git/               # Git repositories
~/Downloads/         # Downloads folder
~/Documents/         # Documents folder
~/.config/           # XDG config directory
~/.local/bin/        # User binaries
~/.local/share/      # User data
~/.local/state/      # User state
~/.cache/zsh/        # Zsh cache
~/.local/state/zsh/  # Zsh state (history)
```

**Source**:
```bash
#!/bin/bash
set -euo pipefail

echo "Creating standard directories..."

mkdir -p "${HOME}"/{Projects,git,Downloads,Documents}
mkdir -p "${HOME}/.config"
mkdir -p "${HOME}/.local"/{bin,share,state}
mkdir -p "${HOME}/.cache/zsh"
mkdir -p "${HOME}/.local/state/zsh"

echo "Directories created successfully."
```

---

#### `run_onchange_before_install-packages-darwin.sh.tmpl`

**Purpose**: Installs Homebrew and all packages on macOS.

**Runs**: When package list changes (content hash)

**OS**: macOS only (filename indicates darwin)

**Actions**:
1. Installs Homebrew if missing
2. Installs 108+ Homebrew packages and casks
3. Installs npm global packages
4. Installs fonts

**Key Packages**:
- Development: neovim, git, node, python, go, rust
- CLI: ripgrep, fd, bat, fzf, jq, yq
- DevOps: docker, kubectl, terraform, ansible
- GUI (if detected): iTerm2, Chrome, Slack

See [PACKAGES.md](PACKAGES.md) for complete list.

---

#### `run_onchange_before_install-packages-linux.sh.tmpl`

**Purpose**: Installs packages on Linux distributions.

**Runs**: When package list changes

**OS**: Linux only

**Supports**:
- Arch Linux (pacman)
- Ubuntu/Debian (apt)
- Fedora (dnf)

**Actions**:
1. Detects distribution
2. Updates package cache
3. Installs development tools
4. Installs GUI apps if X11/Wayland detected

---

### After Scripts

#### `run_once_after_01-install-ohmyzsh.sh.tmpl`

**Purpose**: Installs Oh My Zsh and Powerlevel10k theme.

**Runs**: Once, after files are applied

**Actions**:
1. Installs Oh My Zsh (unattended mode)
2. Clones Powerlevel10k theme

**Source**:
```bash
#!/bin/bash
set -euo pipefail

if [[ ! -d "${HOME}/.oh-my-zsh" ]]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Install Powerlevel10k theme
P10K_DIR="${HOME}/.oh-my-zsh/custom/themes/powerlevel10k"
if [[ ! -d "${P10K_DIR}" ]]; then
    echo "Installing Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${P10K_DIR}"
fi

echo "Oh My Zsh and Powerlevel10k installed successfully."
```

---

#### `run_once_after_02-generate-ssh-keys.sh.tmpl`

**Purpose**: Generates Ed25519 SSH keys.

**Runs**: Once, after files are applied

**Actions**:
1. Generates Ed25519 SSH key pair
2. Adds to macOS keychain (on Darwin)
3. Displays public key for adding to GitHub/GitLab

**Source** (templated):
```bash
#!/bin/bash
set -euo pipefail

SSH_DIR="{{ .chezmoi.homeDir }}/.ssh"

if [[ ! -f "${SSH_DIR}/id_ed25519" ]]; then
    echo "Generating SSH key..."
    ssh-keygen -t ed25519 -C "{{ .git.email }}" -f "${SSH_DIR}/id_ed25519" -N ""

    {{ if .machine.isDarwin }}
    # Add to macOS keychain
    ssh-add --apple-use-keychain "${SSH_DIR}/id_ed25519"
    {{ end }}

    echo "SSH key generated: ${SSH_DIR}/id_ed25519.pub"
    echo "Add this to your GitHub/GitLab account:"
    cat "${SSH_DIR}/id_ed25519.pub"
else
    echo "SSH key already exists, skipping..."
fi
```

## Script State Management

### How State is Tracked

Chezmoi stores script execution state in:
```
~/.local/share/chezmoi/.chezmoistate.boltdb
```

- **run_once_**: Records that script has run; never runs again
- **run_onchange_**: Stores content hash; reruns if hash changes

### Viewing State

```bash
# Show script state
chezmoi state dump
```

### Force Re-run Scripts

To re-run `run_once_*` scripts:

```bash
# Clear all script state
chezmoi state delete-bucket --bucket=scriptState

# Re-apply (scripts will run again)
chezmoi apply
```

### Skip Scripts

```bash
# Apply files only, skip all scripts
chezmoi apply --exclude scripts

# Apply only scripts
chezmoi apply --include scripts
```

## Writing New Scripts

### File Naming

```
run_once_before_00-my-script.sh        # Runs once, before files, order 00
run_once_after_10-another.sh.tmpl      # Runs once, after files, order 10, templated
run_onchange_before_packages.sh.tmpl   # Runs on change, before files, templated
```

### Template Considerations

Add `.tmpl` suffix if script needs template variables:

```bash
#!/bin/bash
# run_once_after_example.sh.tmpl

{{ if .machine.isDarwin }}
echo "Setting up macOS..."
# macOS-specific setup
{{ end }}

{{ if .machine.isWork }}
echo "Configuring work tools..."
# Work-specific setup
{{ end }}
```

### Best Practices

1. **Idempotency**: Scripts should be safe to run multiple times
   ```bash
   # Good: Check before creating
   if [[ ! -d "$DIR" ]]; then
       mkdir -p "$DIR"
   fi

   # Good: Use mkdir -p (idempotent)
   mkdir -p "$DIR"
   ```

2. **Error Handling**: Use `set -euo pipefail`
   ```bash
   #!/bin/bash
   set -euo pipefail
   ```

3. **Progress Messages**: Show what's happening
   ```bash
   echo "Installing dependencies..."
   # ... commands
   echo "Dependencies installed successfully."
   ```

4. **Conditional Execution**: Skip if already done
   ```bash
   if command -v some-tool &> /dev/null; then
       echo "some-tool already installed, skipping..."
       exit 0
   fi
   ```

## Debugging Scripts

### Verbose Mode

```bash
# See scripts being executed
chezmoi apply -v
```

### Dry Run

```bash
# See what would run without executing
chezmoi apply --dry-run -v
```

### Test Script Output

```bash
# View templated script content
chezmoi cat ~/.local/share/chezmoi/run_once_after_01-install-ohmyzsh.sh.tmpl

# Or execute template directly
chezmoi execute-template < run_once_after_01-install-ohmyzsh.sh.tmpl
```

## Related Documentation

- [ARCHITECTURE.md](ARCHITECTURE.md) - Script execution in the overall flow
- [TEMPLATES.md](TEMPLATES.md) - Template syntax for .tmpl scripts
- [PACKAGES.md](PACKAGES.md) - What the package scripts install
