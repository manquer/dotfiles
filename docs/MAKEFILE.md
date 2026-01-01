# Makefile Documentation

The dotfiles Makefile provides a unified interface for managing your configuration, inspired by the ansible-hardening workflow pattern.

## Design Philosophy

- **Self-documenting**: `make help` shows all commands
- **Safety-first**: Dry-run and confirmation prompts
- **Git-integrated**: Built-in version control workflow
- **Cross-platform**: Works on macOS and Linux
- **Automation**: Combines multiple steps into single commands

## Command Reference

### Getting Started

#### `make help`
Display all available commands with descriptions.

```bash
make help
```

#### `make init`
Initialize chezmoi by cloning your dotfiles repository. Prompts for repo URL.

```bash
make init
```

### Daily Workflow

#### `make apply`
Apply dotfiles to the system. Safe to run multiple times.

```bash
make apply
```

#### `make diff`
Show what would change without applying.

```bash
make diff
```

#### `make update`
Pull latest changes from remote and apply in one command.

```bash
make update
```

Equivalent to:
```bash
make pull && make apply
```

### Testing & Verification

#### `make test`
Dry-run mode - shows what would happen without making changes.

```bash
make test
```

#### `make check`
Verify dotfiles without applying changes (verbose dry-run).

```bash
make check
```

#### `make verify`
Verify all dotfiles are correctly applied.

```bash
make verify
```

#### `make doctor`
Run chezmoi diagnostics to identify issues.

```bash
make doctor
```

### Git Workflow

#### `make git-status`
Show git status in the source directory.

```bash
make git-status
```

#### `make git-log`
View last 10 commits with graph.

```bash
make git-log
```

#### `make commit`
Stage and commit changes. Prompts for commit message.

```bash
make commit
```

Example:
```bash
$ make commit
Enter commit message:
Add new zsh plugin for kubectl
[main abc123d] Add new zsh plugin for kubectl
 1 file changed, 3 insertions(+)
```

#### `make push`
Push committed changes to remote repository.

```bash
make push
```

#### `make pull`
Pull latest changes from remote.

```bash
make pull
```

### File Management

#### `make edit`
Edit a dotfile with chezmoi. Prompts for filename.

```bash
make edit
```

Example:
```bash
$ make edit
Enter filename to edit (e.g., .zshrc):
.zshrc
# Opens in $EDITOR
```

#### `make add`
Add a file to chezmoi management. Prompts for file path.

```bash
make add
```

Example:
```bash
$ make add
Enter file path to add (absolute or relative to ~):
.config/starship.toml
```

#### `make remove`
Remove a file from chezmoi management (doesn't delete from system).

```bash
make remove
```

### Installation & Setup

#### `make install`
Install all dependencies based on OS.

```bash
make install
```

For macOS:
- Checks for Homebrew
- Installs if missing
- Runs package installation script

For Linux:
- Detects distribution (Arch/Ubuntu/Fedora)
- Runs appropriate package manager

#### `make packages-darwin`
Install macOS packages only (Homebrew + npm).

```bash
make packages-darwin
```

#### `make packages-linux`
Install Linux packages only.

```bash
make packages-linux
```

#### `make setup-ohmyzsh`
Install Oh My Zsh and Powerlevel10k theme.

```bash
make setup-ohmyzsh
```

#### `make setup-ssh`
Generate SSH keys using chezmoi template.

```bash
make setup-ssh
```

### Maintenance

#### `make backup`
Backup current configuration to timestamped directory.

```bash
make backup
```

Creates:
```
~/dotfiles-backup-20250131-143022/
├── .config/
└── .ssh/
```

#### `make clean`
Clean chezmoi cache and temporary files.

```bash
make clean
```

#### `make lint`
Lint all shell scripts in dotfiles using shellcheck.

```bash
make lint
```

### Advanced

#### `make data`
Show all template data available to dotfiles.

```bash
make data
```

Shows variables like:
- `.machine.type`
- `.machine.os`
- `.machine.hasGui`
- `.git.name`
- `.git.email`
- etc.

#### `make execute-template`
Execute a template expression interactively.

```bash
make execute-template
```

Example:
```bash
$ make execute-template
Enter template expression (e.g., {{ .chezmoi.os }}):
{{ .machine.type }}
work
```

#### `make cd`
Open the chezmoi source directory in a new shell.

```bash
make cd
```

#### `make status`
Show chezmoi status (modified/added/deleted files).

```bash
make status
```

#### `make docs`
View the README documentation.

```bash
make docs
```

#### `make version`
Show versions of chezmoi, git, and Homebrew.

```bash
make version
```

### Safety Features

#### `make apply-force`
Force apply all dotfiles, overwriting local changes.

**⚠️ Warning**: This overwrites any local modifications!

```bash
make apply-force
```

Requires confirmation:
```
WARNING: This will overwrite any local changes!
Press Ctrl+C to cancel, or Enter to continue...
```

## Workflow Examples

### New Machine Setup

```bash
# Install chezmoi
sh -c "$(curl -fsLS get.chezmoi.io)"

# Clone and initialize
git clone https://github.com/username/dotfiles.git ~/.local/share/chezmoi
cd ~/.local/share/chezmoi

# Review and apply
make diff
make apply

# Install everything
make install

# Reload shell
exec zsh
```

### Daily Development

```bash
# Check for changes
make diff

# Apply if looks good
make apply

# Pull updates from team/other machines
make update
```

### Making Changes

```bash
# Edit a file
make edit
# Enter: .zshrc

# Test changes
make test

# Apply changes
make apply

# Commit and push
make commit
# Enter: "Update zsh configuration"
make push
```

### Package Management

```bash
# Add new package to Brewfile
make edit
# Edit run_onchange_before_install-packages-darwin.sh.tmpl

# Test installation (dry-run)
make test

# Apply and install
make apply

# Packages auto-install via run_onchange_ script
```

### Troubleshooting

```bash
# Check status
make status

# Run diagnostics
make doctor

# View git history
make git-log

# See what changed
make diff

# Restore from backup
make backup  # First, backup current state
make apply-force  # Then restore from repo
```

## Tips & Best Practices

1. **Always run `make diff` before `make apply`**
   - Preview changes to avoid surprises

2. **Use `make test` for major changes**
   - Validates without modifying files

3. **Commit frequently**
   ```bash
   make commit && make push
   ```

4. **Backup before major changes**
   ```bash
   make backup
   ```

5. **Update regularly**
   ```bash
   make update
   ```

6. **Use `make doctor` when things break**
   - Identifies common issues

7. **Lint before committing**
   ```bash
   make lint
   make commit
   ```

## Comparison with Direct Commands

| Makefile | chezmoi | Notes |
|----------|---------|-------|
| `make apply` | `chezmoi apply` | Shorter to type |
| `make update` | `cd ~/.local/share/chezmoi && git pull && chezmoi apply` | Combines multiple steps |
| `make commit` | `cd ~/.local/share/chezmoi && git add -A && git commit -m "msg"` | Interactive prompt |
| `make install` | N/A | OS detection + package installation |
| `make backup` | N/A | Not built into chezmoi |
| `make test` | `chezmoi apply --dry-run --verbose` | Clearer naming |

## Customization

Edit the Makefile to add your own targets:

```makefile
my-custom-task: ## Description of my task
	@echo "Running custom task..."
	# Your commands here
```

Then run:
```bash
make my-custom-task
```

The `##` comment makes it appear in `make help`.

## Integration with CI/CD

The Makefile can be used in automation:

```yaml
# GitHub Actions example
- name: Test dotfiles
  run: |
    cd ~/.local/share/chezmoi
    make test
```

```yaml
# Pre-commit hook
#!/bin/bash
cd ~/.local/share/chezmoi
make lint
make test
```
