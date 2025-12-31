# Git Configuration

## Key Features

### Commit Settings

```toml
[commit]
  verbose = true      # Show diff in commit message editor
  gpgsign = true      # Sign all commits with GPG
```

### Diff Algorithm

```toml
[diff]
  algorithm = histogram    # Better diff algorithm
  colorMoved = plain      # Highlight moved code
  renames = true          # Detect renames
```

### Delta Integration

Uses [delta](https://github.com/dandavison/delta) as pager:
- Side-by-side diffs
- Line numbers
- Syntax highlighting

### Rebase Settings

```toml
[rebase]
  autoSquash = true    # Auto-squash fixup! commits
  autoStash = true     # Auto-stash before rebase
  updateRefs = true    # Update branch pointers
```

### Merge Strategy

```toml
[merge]
  conflictstyle = zdiff3    # Show base, ours, and theirs
```

Better conflict markers with common ancestor.

### Push Behavior

```toml
[push]
  default = simple          # Push current branch
  autoSetupRemote = true    # Create remote branch
  followTags = true         # Push annotated tags
```

### Fetch Settings

```toml
[fetch]
  prune = true         # Remove deleted remote branches
  pruneTags = true     # Remove deleted tags
  all = true           # Fetch from all remotes
```

## Signing Setup

```bash
# Import GPG key
gpg --import private-key.asc

# Trust key
gpg --edit-key YOUR_KEY_ID trust

# Configure Git
git config --global user.signingkey YOUR_KEY_ID
git config --global commit.gpgsign true
```

## Machine-Specific

User info is templated:
- `user.name` - From chezmoi prompt
- `user.email` - From chezmoi prompt
- `user.signingkey` - From chezmoi prompt
