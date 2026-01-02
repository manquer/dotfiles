# Git Configuration

Advanced git setup with delta diff viewer, GPG signing, automatic stashing, and modern workflow defaults.

## Overview

| Feature | Setting |
|---------|---------|
| **Diff Tool** | delta (side-by-side, line numbers) |
| **Merge Style** | zdiff3 (shows common ancestor) |
| **Commit Signing** | GPG enabled |
| **Default Branch** | develop |
| **Editor** | neovim |

## Complete Configuration

### User Identity

```toml
[user]
    name = {{ .git.name }}         # From chezmoi prompt
    email = {{ .git.email }}       # From chezmoi prompt
    signingkey = {{ .git.signingkey }}  # GPG key ID
```

### Core Settings

```toml
[core]
    editor = nvim        # Use Neovim for commits
    pager = delta        # Use delta for all diffs

[init]
    defaultBranch = develop  # New repos start with 'develop'

[help]
    autocorrect = prompt  # Suggest corrections for typos
```

### Diff Configuration

```toml
[diff]
    algorithm = histogram    # Better diff algorithm
    colorMoved = plain       # Highlight moved lines
    mnemonicPrefix = true    # Use i/w/c instead of a/b
    renames = true           # Detect file renames
```

The `histogram` algorithm provides better diffs for:
- Code refactoring
- Large file changes
- Moved code blocks

### Delta Integration

[Delta](https://github.com/dandavison/delta) provides enhanced diff viewing:

```toml
[delta]
    navigate = true      # Use n/N to jump between sections
    dark = true          # Dark theme
    side-by-side = true  # Two-column diff view
    line-numbers = true  # Show line numbers

[interactive]
    diffFilter = delta --color-only
```

### Commit Settings

```toml
[commit]
    verbose = true   # Show diff in commit message editor
    gpgsign = true   # Sign all commits with GPG
```

### Tag Settings

```toml
[tag]
    gpgSign = true              # Sign all tags
    sort = version:refname      # Sort tags by version number
```

### Push Behavior

```toml
[push]
    default = simple        # Push current branch only
    autoSetupRemote = true  # Auto-create remote branch
    followTags = true       # Push annotated tags
```

### Fetch Settings

```toml
[fetch]
    prune = true       # Remove deleted remote branches
    pruneTags = true   # Remove deleted remote tags
    all = true         # Fetch from all remotes
```

### Branch Settings

```toml
[branch]
    sort = -committerdate  # Show recently used branches first

[column]
    ui = auto  # Display in columns when possible
```

### Rebase Workflow

```toml
[rebase]
    autoSquash = true   # Auto-squash fixup! commits
    autoStash = true    # Stash before rebase, apply after
    updateRefs = true   # Update branch pointers
```

These settings enable a smoother rebase workflow:
- `fixup! commit-msg` commits are automatically squashed
- Uncommitted changes are stashed and re-applied
- Branch references are updated after rebase

### Merge Strategy

```toml
[merge]
    conflictstyle = zdiff3
```

The `zdiff3` style shows three versions in conflicts:

```
<<<<<<< HEAD (your changes)
your code
||||||| common ancestor
original code
=======
their code
>>>>>>> feature-branch
```

### Rerere (Reuse Recorded Resolution)

```toml
[rerere]
    enabled = true      # Remember conflict resolutions
    autoupdate = true   # Auto-stage rerere resolutions
```

Once you resolve a conflict, git remembers and applies the same resolution if the conflict reoccurs.

### Git LFS

```toml
[lfs]
    allowincompletepush = true  # Allow partial pushes

[filter "lfs"]
    clean = git-lfs clean -- %f
    smudge = git-lfs smudge -- %f
    process = git-lfs filter-process
    required = true
```

## GPG Signing Setup

### 1. Generate GPG Key

```bash
# Generate new key
gpg --full-generate-key

# Choose:
# - RSA and RSA
# - 4096 bits
# - No expiration (or your preference)
# - Your name and email
```

### 2. Get Key ID

```bash
gpg --list-secret-keys --keyid-format=long

# Output like:
# sec   rsa4096/YOUR_KEY_ID 2024-01-01
```

### 3. Configure Git

During `chezmoi init`, enter your key ID when prompted:

```
Git GPG signing key (leave empty if none): YOUR_KEY_ID
```

Or manually:

```bash
git config --global user.signingkey YOUR_KEY_ID
```

### 4. Export Public Key (for GitHub/GitLab)

```bash
gpg --armor --export YOUR_KEY_ID
```

Add this to GitHub: Settings → SSH and GPG keys → New GPG key

### 5. Configure GPG Agent

For macOS with pinentry:

```bash
# Install pinentry
brew install pinentry-mac

# Configure gpg-agent
echo "pinentry-program $(which pinentry-mac)" >> ~/.gnupg/gpg-agent.conf

# Restart agent
gpgconf --kill gpg-agent
```

## Shell Aliases

From `.aliases.zsh`:

| Alias | Command |
|-------|---------|
| `gst` | `git status` |
| `gco` | `git checkout` |
| `gcb` | `git checkout -b` |
| `gp` | `git push` |
| `gP` | `git pull` |
| `glog` | `git log --oneline --graph --decorate` |
| `gdiff` | `git diff` |
| `gadd` | `git add` |
| `gcom` | `git commit` |
| `gbr` | `git branch` |

## Workflow Examples

### Feature Branch

```bash
# Create and switch to feature branch
gcb feature/my-feature

# Make changes and commit
gadd .
gcom -m "Add new feature"

# Push (auto-creates remote branch)
gp
```

### Fixup Commit

```bash
# Make a fixup commit
git commit --fixup HEAD~2

# Later, squash automatically during rebase
git rebase -i main  # autoSquash handles the rest
```

### Stash-Free Rebase

```bash
# With autoStash, no need to manually stash
git rebase main
# Uncommitted changes are preserved
```

### View Diff with Delta

```bash
# Beautiful side-by-side diff
git diff

# Navigate sections
# Press n (next) or N (previous)
```

## Neovim Integration

Git tools in Neovim (see [NEOVIM.md](NEOVIM.md)):

| Plugin | Purpose |
|--------|---------|
| `tpope/vim-fugitive` | Git commands in Vim |
| `lewis6991/gitsigns.nvim` | Git signs in gutter |
| `pwntester/octo.nvim` | GitHub PR/Issues |
| `ThePrimeagen/git-worktree.nvim` | Worktree management |

## Troubleshooting

### GPG Signing Fails

```bash
# Test GPG
echo "test" | gpg --clearsign

# If it hangs, restart agent
gpgconf --kill gpg-agent

# Check TTY
export GPG_TTY=$(tty)
```

### Delta Not Showing Colors

```bash
# Ensure delta is installed
brew install git-delta

# Check it's being used
git config --get core.pager
```

### View Current Configuration

```bash
# All settings
git config --list --show-origin

# Specific setting
git config user.email
```

## Template Variables

The gitconfig uses chezmoi template variables:

| Variable | Prompted | Purpose |
|----------|----------|---------|
| `.git.name` | Yes | User name for commits |
| `.git.email` | Yes | Email for commits |
| `.git.signingkey` | Yes | GPG key ID (optional) |

## Related Documentation

- [TEMPLATES.md](TEMPLATES.md) - How template variables work
- [NEOVIM.md](NEOVIM.md) - Git integration in Neovim
- [delta](https://github.com/dandavison/delta) - Diff viewer
