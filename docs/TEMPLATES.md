# Templates

Chezmoi uses [Go templates](https://pkg.go.dev/text/template) to generate configuration files dynamically based on the current machine's environment.

## Quick Reference

```go
{{ .machine.os }}           // "darwin" or "linux"
{{ .machine.type }}         // "work" or "personal"
{{ .machine.isDarwin }}     // true/false
{{ .machine.isLinux }}      // true/false
{{ .machine.isWork }}       // true/false
{{ .machine.hasGui }}       // true/false
{{ .git.name }}             // "Your Name"
{{ .git.email }}            // "email@example.com"
{{ .chezmoi.homeDir }}      // "/Users/username"
```

## Template Variables

All variables are defined in `.chezmoi.toml.tmpl` and available in any `.tmpl` file.

### Machine Variables (`.machine`)

| Variable | Type | Description | Example |
|----------|------|-------------|---------|
| `.machine.type` | string | Machine profile | `"work"` or `"personal"` |
| `.machine.hostname` | string | Computer hostname | `"macbook-pro"` |
| `.machine.os` | string | Operating system | `"darwin"` or `"linux"` |
| `.machine.arch` | string | CPU architecture | `"arm64"`, `"amd64"` |
| `.machine.isDarwin` | bool | Is macOS | `true`/`false` |
| `.machine.isLinux` | bool | Is Linux | `true`/`false` |
| `.machine.isArch` | bool | Is Arch Linux | `true`/`false` |
| `.machine.isWork` | bool | Work machine | `true`/`false` |
| `.machine.isPersonal` | bool | Personal machine | `true`/`false` |
| `.machine.hasGui` | bool | Has GUI environment | `true`/`false` |

### Git Variables (`.git`)

| Variable | Type | Description |
|----------|------|-------------|
| `.git.name` | string | Git user name |
| `.git.email` | string | Git user email |
| `.git.signingkey` | string | GPG signing key ID (optional) |

### Codex Variables (`.codex`)

| Variable | Type | Description |
|----------|------|-------------|
| `.codex.baseUrl` | string | LiteLLM endpoint (work only) |

### Built-in Chezmoi Variables (`.chezmoi`)

| Variable | Description |
|----------|-------------|
| `.chezmoi.os` | Same as `machine.os` |
| `.chezmoi.arch` | Same as `machine.arch` |
| `.chezmoi.hostname` | Same as `machine.hostname` |
| `.chezmoi.homeDir` | User home directory path |
| `.chezmoi.sourceDir` | Chezmoi source directory |
| `.chezmoi.username` | Current username |

## Template Syntax

### Conditionals

```go
// Basic if
{{ if .machine.isDarwin }}
# macOS specific configuration
{{ end }}

// If-else
{{ if .machine.isWork }}
export WORK_VAR="enabled"
{{ else }}
export WORK_VAR="disabled"
{{ end }}

// If-else if-else
{{ if .machine.isDarwin }}
# macOS
{{ else if .machine.isArch }}
# Arch Linux
{{ else }}
# Other Linux
{{ end }}

// Negation
{{ if not .machine.hasGui }}
# Headless server
{{ end }}

// Multiple conditions (and/or)
{{ if and .machine.isWork .machine.isDarwin }}
# Work Mac only
{{ end }}

{{ if or .machine.isArch (eq .machine.os "debian") }}
# Arch or Debian
{{ end }}
```

### String Operations

```go
// Output variable
user.name = {{ .git.name | quote }}

// Check if string contains
{{ if contains "work" .machine.hostname }}

// Check equality
{{ if eq .machine.type "work" }}

// Not equal
{{ if ne .machine.os "darwin" }}
```

### Functions

| Function | Description | Example |
|----------|-------------|---------|
| `quote` | Wrap in quotes | `{{ .git.email \| quote }}` → `"email@example.com"` |
| `contains` | String contains | `{{ if contains "work" .hostname }}` |
| `eq` | Equal | `{{ if eq .machine.type "work" }}` |
| `ne` | Not equal | `{{ if ne .machine.os "darwin" }}` |
| `and` | Logical AND | `{{ if and .isWork .isDarwin }}` |
| `or` | Logical OR | `{{ if or .isArch .isUbuntu }}` |
| `not` | Logical NOT | `{{ if not .hasGui }}` |
| `env` | Environment variable | `{{ env "HOME" }}` |
| `stat` | Check file exists | `{{ if stat "/etc/arch-release" }}` |

## Configuration File (`.chezmoi.toml.tmpl`)

This is the main configuration template that sets up all variables:

```go
{{- /* Detect OS */}}
{{- $isDarwin := eq .chezmoi.os "darwin" -}}
{{- $isLinux := eq .chezmoi.os "linux" -}}
{{- $isArch := and $isLinux (stat "/etc/arch-release") -}}

{{- /* Detect machine type from hostname */}}
{{- $machineType := "personal" -}}
{{- if or (contains "work" .chezmoi.hostname) (contains "corp" .chezmoi.hostname) (contains "talview" .chezmoi.hostname) -}}
{{-   $machineType = "work" -}}
{{- end -}}

{{- /* Prompt user to confirm/override */}}
{{- $machineType := promptStringOnce . "machine.type" "Machine type (work/personal)" $machineType -}}

{{- /* Detect GUI environment */}}
{{- $hasGui := false -}}
{{- if $isDarwin -}}
{{-   $hasGui = true -}}
{{- else if $isLinux -}}
{{-   $hasGui = or (env "DISPLAY") (env "WAYLAND_DISPLAY") -}}
{{- end -}}

{{- /* Prompt for git credentials */}}
{{- $name := promptStringOnce . "git.name" "Git user name" -}}
{{- $email := promptStringOnce . "git.email" "Git user email" -}}

[data]
    [data.machine]
        type = {{ $machineType | quote }}
        os = {{ .chezmoi.os | quote }}
        # ... more variables
```

### Prompt Functions

| Function | Description |
|----------|-------------|
| `promptString` | Always prompt for value |
| `promptStringOnce` | Prompt once, save for future |
| `promptBool` | Prompt for boolean |
| `promptBoolOnce` | Prompt once for boolean |
| `promptInt` | Prompt for integer |

## Common Patterns

### OS-Specific Configuration

```go
{{ if .machine.isDarwin -}}
# Homebrew paths
export PATH="/opt/homebrew/bin:$PATH"
{{ else if .machine.isLinux -}}
# Linux paths
export PATH="$HOME/.local/bin:$PATH"
{{ end -}}
```

### Work vs Personal

```go
{{ if .machine.isWork -}}
# Work-specific tools
export JIRA_URL="https://company.atlassian.net"
{{ end -}}

{{ if .machine.isPersonal -}}
# Personal projects
export PROJECTS="$HOME/personal"
{{ end -}}
```

### GUI-Conditional Installation

In `run_onchange_before_install-packages-darwin.sh.tmpl`:

```go
{{ if .machine.hasGui }}
# GUI Applications
cask "iterm2"
cask "slack"
cask "notion"
{{ end }}
```

### Git Configuration

In `dot_gitconfig.tmpl`:

```go
[user]
    name = {{ .git.name }}
    email = {{ .git.email }}
{{ if .git.signingkey }}
    signingkey = {{ .git.signingkey }}
[commit]
    gpgsign = true
{{ end }}
```

### Conditional File Paths

```go
{{ if .machine.isDarwin -}}
{{ .chezmoi.homeDir }}/Library/Application Support/
{{- else -}}
{{ .chezmoi.homeDir }}/.config/
{{- end -}}
```

## Debugging Templates

### View Current Data

```bash
# Show all template data
chezmoi data

# Or with make
make data
```

### Test Template Expression

```bash
# Interactive template testing
chezmoi execute-template '{{ .machine.type }}'

# Or with make
make execute-template
```

### Preview File Output

```bash
# See what a template will produce
chezmoi cat ~/.zshrc

# Show diff between template output and current file
chezmoi diff
```

### Verbose Apply

```bash
# See templates being processed
chezmoi apply -v
```

## Whitespace Control

Templates can leave unwanted whitespace. Use `-` to trim:

```go
// Without whitespace control (leaves blank lines)
{{ if .machine.isDarwin }}
export MAC=true
{{ end }}

// With whitespace control (clean output)
{{- if .machine.isDarwin }}
export MAC=true
{{- end }}
```

| Syntax | Effect |
|--------|--------|
| `{{-` | Trim whitespace before |
| `-}}` | Trim whitespace after |
| `{{- -}}` | Trim both sides |

## Template Files in This Repository

| File | Purpose |
|------|---------|
| `.chezmoi.toml.tmpl` | Main configuration, variable definitions |
| `dot_zshrc.tmpl` | Shell configuration with OS/profile conditionals |
| `dot_gitconfig.tmpl` | Git config with user credentials |
| `dot_config/zsh/conf.d/00-path.zsh.tmpl` | PATH with OS-specific entries |
| `dot_config/zsh/conf.d/10-tools.zsh.tmpl` | Tool initialization |
| `run_onchange_before_install-packages-darwin.sh.tmpl` | macOS package installation |
| `run_onchange_before_install-packages-linux.sh.tmpl` | Linux package installation |
| `run_once_after_02-generate-ssh-keys.sh.tmpl` | SSH key generation |

## Related Documentation

- [PROFILES.md](PROFILES.md) - Work vs personal profile details
- [ARCHITECTURE.md](ARCHITECTURE.md) - How templates fit in the system
- [Chezmoi Template Guide](https://www.chezmoi.io/user-guide/templating/)
