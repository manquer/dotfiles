# Scripts

Chezmoi supports running scripts as part of the dotfiles application process. Scripts automate setup tasks like installing packages, configuring tools, and generating keys.

## Script Types

| Type | Prefix | Runs When |
|------|--------|-----------|
| **run_once** | `run_once_` | First time only (state tracked) |
| **run_onchange** | `run_onchange_` | When script content changes (hash-based) |
| **run** | `run_` | Every apply (no state tracked) |

## Execution Order

Scripts run in this order:

1. `run_once_before_*` (alphabetically)
2. `run_onchange_before_*` (alphabetically)
3. **File application**
4. `run_once_after_*` (alphabetically)
5. `run_onchange_after_*` (alphabetically)
6. `run_after_*` (alphabetically)

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

#### `run_after_pin-herdr.sh.tmpl`

**Purpose**: Keeps the `herdr` binary on the pinned version rather than homebrew-core's latest.

**Runs**: Every apply, after files (macOS only)

**Actions**: Calls `~/.local/bin/herdr-pin`, which is a no-op once the pin is in
place. homebrew-core ships a single unversioned `herdr` formula, so the pin is
enforced by pouring the official bottle for the pinned version into the Cellar
and running `brew pin`.

`herdr-pin` will not relink the binary while herdr workspaces are attached -
that would kill them - so it reports the swap as deferred and leaves the current
version in place. Running on every apply (rather than `run_onchange_`) is what
lets a deferred swap land on the first apply after the servers are stopped.

See [`herdr-pin`](#herdr-pin) below for the command surface and for how to move
the pin to a new version.

---

## User Binaries (`~/.local/bin`)

Not chezmoi scripts: these are managed files under `dot_local/bin/`, applied to
`~/.local/bin` (already on `PATH`, see [SHELL.md](SHELL.md)) and run by hand.

### `herdr-pin`

**Purpose**: Holds the local `herdr` client at a known-good version - currently
**0.9.0** - instead of tracking homebrew-core's latest.

homebrew-core carries a single unversioned `herdr` formula, so brew on its own
cannot express "stay on 0.9.0". The script pours the official bottle for the
pinned version out of ghcr into the Cellar, links that keg and pins the formula
so `brew upgrade` leaves it alone.

```bash
herdr-pin --status    # installed, linked and pinned state, plus live sessions
herdr-pin             # enforce the pin; defers while sessions are attached
herdr-pin --force     # swap now, killing attached sessions
herdr-pin --release   # drop the pin, return to homebrew-core's latest
```

Relinking tears down every attached herdr client, so the swap only runs when no
herdr process is alive. While workspaces are up the script pre-fetches the bottle,
reports the swap as deferred and exits 0 - which is what makes it safe to call
from [`run_after_pin-herdr.sh.tmpl`](#run_after_pin-herdrshtmpl) on every apply.

`PINNED_VERSION` at the top of the script is the target, and
`HERDR_PINNED_VERSION` overrides it for a one-off run. To move the pin:

```bash
herdr server stop                      # the swap defers while the server is up
$EDITOR dot_local/bin/executable_herdr-pin   # bump PINNED_VERSION
chezmoi apply                          # run_after_ hook performs the swap
herdr server                           # bring the server back on the new version
```

---

### `devcontainer-secrets-push`

**Purpose**: Writes the Keychain secrets plus the non-secret `TURBO_*` pair into a
devcontainer's `~/.secrets.zsh`, and reinstalls `turbo-remote-cache-seed` there.

**Why it exists**: `/home/node` does not survive `devpod up --recreate` - only the
`/workspace` bind mount does - so `~/.secrets.zsh` and the `~/.zshenv` that sources
it are lost on every recreate, silently. Shells still start; `turbo` just stops
using the remote cache.

```bash
devcontainer-secrets-push                        # every crusible-dev-*.devpod host in ~/.ssh/config
devcontainer-secrets-push crusible-dev-4.devpod  # named targets only
```

Values are read live from the macOS Keychain (service `chezmoi`) and `~/.env` -
the same two sources `conf.d/{05-env,15-secrets}.zsh` read - and travel on stdin,
never on argv, which is visible in `ps` on a shared host. `~/.zshenv` is the
target rather than `~/.zshrc` because a non-interactive `zsh -c`, which is what an
agent tool call and a `mise` task run, does not source `~/.zshrc`.

Already-running panes and agents keep their frozen environment: turbo is covered
by the seeded `.turbo/config.json`, everything else needs `source ~/.secrets.zsh`
in an idle pane or an agent restart.

---

### `turbo-remote-cache-seed`

**Purpose**: Writes `.turbo/config.json` into every worktree of a repository, so the
Turborepo remote cache is configured by file rather than by environment.

**Why a file**: an environment variable reaches only processes started after it was
set, and a long-lived agent, a herdr pane or a dev server each froze its copy at
start. `turbo` re-reads `<worktree>/.turbo/config.json` on every invocation, so a
process with a stale environment still gets the cache.

```bash
turbo-remote-cache-seed              # every worktree of the repo in $PWD
turbo-remote-cache-seed ~/git/repo   # named repository roots
```

`TURBO_TOKEN`, `TURBO_API` and `TURBO_TEAM` resolve from the environment first,
then the Keychain, then `~/.env`, so the same script runs on the Mac and inside a
container. Each file is written `0600` through a temp file in the same directory,
so no worktree ever sees a half-written config.

This file outranks the environment, which matters when measuring: a "cold" turbo
number needs `.turbo/config.json` moved aside, not `TURBO_*` unset.

---

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
