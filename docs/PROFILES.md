# Machine Profiles

This dotfiles setup supports two machine profiles: **work** and **personal**. The profile determines which packages are installed, which configurations are applied, and which environment variables are set.

## Profile Detection

### Automatic Detection

The profile is auto-detected from your machine's hostname during `chezmoi init`:

```go
// In .chezmoi.toml.tmpl
{{- $machineType := "personal" -}}
{{- if or (contains "work" .chezmoi.hostname) (contains "corp" .chezmoi.hostname) (contains "talview" .chezmoi.hostname) -}}
{{-   $machineType = "work" -}}
{{- end -}}
```

**Hostnames that trigger "work" profile:**
- Contains `work` (e.g., `macbook-work`)
- Contains `corp` (e.g., `corp-laptop`)
- Contains `talview` (e.g., `talview-dev`)

### Manual Override

During first run, you're prompted to confirm or change:

```
Machine type (work/personal) [personal]:
```

To change later, edit `~/.config/chezmoi/chezmoi.toml`:

```toml
[data.machine]
    type = "work"  # Change to "personal" or "work"
```

Then re-apply:

```bash
chezmoi apply
```

## Profile Differences

### Work Profile

When `.machine.type == "work"`:

| Category | Behavior |
|----------|----------|
| **npm packages** | Installs `@openai/codex` CLI |
| **Environment** | Sets `CODEX_BASE_URL` for LiteLLM proxy |
| **Paths** | Adds work-specific tool paths |
| **Aliases** | Work-related shortcuts |

### Personal Profile

When `.machine.type == "personal"`:

| Category | Behavior |
|----------|----------|
| **npm packages** | Skips work-specific tools |
| **Environment** | No work proxy configuration |
| **Config files** | Excludes `.codex.work/` directory |

## Configuration Examples

### Shell Configuration

In `dot_zshrc.tmpl`:

```go
{{ if .machine.isWork }}
# Work-specific settings
export JIRA_PROJECT="TEAM"
alias standup='open "https://meet.google.com/xxx-xxxx-xxx"'
{{ end }}
```

### Path Configuration

In `dot_config/zsh/conf.d/00-path.zsh.tmpl`:

```go
{{ if .machine.isWork }}
# Work tools path
typeset -U path
path=(
    "$HOME/.work-tools/bin"
    $path
)
{{ end }}
```

### Package Installation

In `run_onchange_before_install-packages-darwin.sh.tmpl`:

```go
# npm globals - work only
{{ if .machine.isWork }}
npm install -g @openai/codex
{{ end }}
```

### Codex Configuration

In `dot_codex.work/private_config.toml.tmpl` (only applied on work machines):

```toml
[api]
base_url = "{{ .codex.baseUrl }}"
```

## File Exclusion

The `.chezmoiignore` file excludes work-specific files on personal machines:

```
{{ if not .machine.isWork }}
.codex.work/
{{ end }}
```

This means:
- **Work machines**: `.codex.work/` directory is applied
- **Personal machines**: `.codex.work/` directory is completely ignored

## Available Profile Variables

| Variable | Type | Description |
|----------|------|-------------|
| `.machine.type` | string | `"work"` or `"personal"` |
| `.machine.isWork` | bool | `true` if work machine |
| `.machine.isPersonal` | bool | `true` if personal machine |

## Combining with OS Detection

Profiles work alongside OS detection:

```go
{{ if and .machine.isWork .machine.isDarwin }}
# Work Mac specific
{{ end }}

{{ if and .machine.isPersonal .machine.isLinux }}
# Personal Linux specific
{{ end }}
```

## Adding New Profile-Specific Configuration

### 1. Add to Template File

```go
{{ if .machine.isWork }}
# Your work-specific config here
{{ end }}
```

### 2. Add Conditional File Inclusion

In `.chezmoiignore`:

```
{{ if not .machine.isWork }}
path/to/work-only-file
{{ end }}
```

### 3. Add New Variable (Optional)

In `.chezmoi.toml.tmpl`:

```go
{{- $workTool := "" -}}
{{- if eq $machineType "work" -}}
{{-   $workTool = promptStringOnce . "work.tool" "Work tool URL" "https://default.url" -}}
{{- end -}}

[data.work]
    tool = {{ $workTool | quote }}
```

## Checking Your Current Profile

```bash
# View all template data including profile
chezmoi data | grep -A5 '"machine"'

# Or just the type
chezmoi execute-template '{{ .machine.type }}'
```

Example output:
```json
"machine": {
    "type": "work",
    "isWork": true,
    "isPersonal": false,
    ...
}
```

## Switching Profiles

To switch a machine's profile:

1. Edit the config:
   ```bash
   $EDITOR ~/.config/chezmoi/chezmoi.toml
   ```

2. Change the type:
   ```toml
   [data.machine]
       type = "personal"  # or "work"
   ```

3. Re-apply:
   ```bash
   chezmoi apply
   ```

4. Reload shell:
   ```bash
   exec zsh
   ```

## Related Documentation

- [TEMPLATES.md](TEMPLATES.md) - Template syntax and all variables
- [PACKAGES.md](PACKAGES.md) - Profile-specific packages
- [ARCHITECTURE.md](ARCHITECTURE.md) - How profiles fit in the system
