# Neovim Configuration

Comprehensive Neovim setup with LSP, AI coding assistants, Git integration, and 60+ plugins.

## Overview

| Feature | Implementation |
|---------|----------------|
| **Plugin Manager** | vim-plug |
| **LSP Client** | CoC (primary), nvim-lspconfig (secondary) |
| **Theme** | Catppuccin |
| **AI Tools** | CodeCompanion, OpenCode, Claude Code |
| **Git Integration** | Fugitive, Gitsigns, Octo, Git Worktree |

## Directory Structure

```
~/.config/nvim/
├── init.vim                    # Entry point (vim-plug + Lua bridge)
├── coc-settings.json           # CoC LSP configuration
└── lua/org/
    ├── init.lua                # Setup orchestrator
    ├── settings/
    │   ├── init.lua            # Settings loader
    │   ├── options.lua         # Editor options
    │   ├── keymaps.lua         # Key bindings
    │   └── autocmds.lua        # Autocommands
    └── plugins/
        ├── init.lua            # Plugin manager setup
        ├── core.lua            # Core/baseline plugins
        ├── ui.lua              # UI/appearance
        ├── navigation.lua      # File navigation
        ├── git.lua             # Git integration
        ├── lsp.lua             # LSP/completion
        ├── tools.lua           # Dev tools
        └── config/             # Plugin configurations
            ├── theme.lua       # Colorscheme
            ├── lsp.lua         # LSP setup
            ├── coc.lua         # CoC completion
            ├── octo.lua        # GitHub integration
            ├── codecompanion.lua # AI assistant
            └── opencode.lua    # OpenCode AI
```

## Plugins by Category

### Core & Editing

| Plugin | Purpose |
|--------|---------|
| `tpope/vim-sensible` | Sane defaults |
| `tpope/vim-surround` | Edit surrounding characters |
| `tpope/vim-repeat` | Extend `.` to plugins |
| `numToStr/Comment.nvim` | Toggle comments |
| `terryma/vim-multiple-cursors` | Multi-cursor editing |
| `Raimondi/delimitMate` | Auto-insert matching brackets |
| `godlygeek/tabular` | Text alignment |
| `Pocco81/auto-save.nvim` | Auto-save (60s debounce) |
| `editorconfig/editorconfig-vim` | EditorConfig support |

### UI & Appearance

| Plugin | Purpose |
|--------|---------|
| `catppuccin/nvim` | Catppuccin colorscheme |
| `vim-airline/vim-airline` | Status line |
| `romgrk/barbar.nvim` | Buffer/tab line |
| `nvim-tree/nvim-web-devicons` | File icons |
| `preservim/vim-indent-guides` | Indentation guides |
| `akinsho/toggleterm.nvim` | Terminal integration |
| `anuvyklack/windows.nvim` | Window management |

### Navigation

| Plugin | Purpose |
|--------|---------|
| `preservim/nerdtree` | File tree explorer |
| `nvim-telescope/telescope.nvim` | Fuzzy finder |
| `ThePrimeagen/harpoon` | Quick file marks |
| `justinmk/vim-sneak` | Two-character jump |
| `majutsushi/tagbar` | Code outline |
| `pechorin/any-jump.vim` | Jump to definition |

### LSP & Completion

| Plugin | Purpose |
|--------|---------|
| `neoclide/coc.nvim` | Main LSP client |
| `neovim/nvim-lspconfig` | Additional LSP configs |
| `b0o/schemastore.nvim` | JSON/YAML schemas |
| `nvim-treesitter/nvim-treesitter` | Syntax highlighting |
| `dense-analysis/ale` | Async linting |
| `kevinhwang91/nvim-ufo` | Code folding |

### Git

| Plugin | Purpose |
|--------|---------|
| `tpope/vim-fugitive` | Git commands |
| `tpope/vim-rhubarb` | GitHub integration |
| `lewis6991/gitsigns.nvim` | Git signs in gutter |
| `f-person/git-blame.nvim` | Inline blame |
| `pwntester/octo.nvim` | GitHub PR/Issues |
| `ThePrimeagen/git-worktree.nvim` | Worktree management |

### AI Assistants

| Plugin | Purpose |
|--------|---------|
| `olimorris/codecompanion.nvim` | Claude-powered assistant |
| `NickvanDyke/opencode.nvim` | OpenCode AI (tmux) |
| `greggh/claude-code.nvim` | Claude Code integration |

### Testing & Tools

| Plugin | Purpose |
|--------|---------|
| `vim-test/vim-test` | Test runner |
| `tpope/vim-dispatch` | Async build/test |
| `preservim/vimux` | Tmux integration |
| `folke/trouble.nvim` | Diagnostics viewer |
| `andythigpen/nvim-coverage` | Coverage visualization |
| `Equilibris/nx.nvim` | Nx monorepo support |

## Key Bindings

### Leader Key: `,`

### File Navigation

| Key | Action |
|-----|--------|
| `<leader>ff` | Find files (Telescope) |
| `<leader>fg` | Live grep (Telescope) |
| `<leader>fb` | List buffers (Telescope) |
| `<leader>fh` | Help tags (Telescope) |
| `<F8>` | Toggle Tagbar |

### Buffer Navigation (Barbar)

| Key | Action |
|-----|--------|
| `<A-,>` / `<A-.>` | Previous/next buffer |
| `<A-1>` to `<A-9>` | Go to buffer 1-9 |
| `<A-0>` | Go to last buffer |
| `<A-c>` | Close buffer |
| `<A-p>` | Pin buffer |
| `<C-p>` | Buffer picker |

### Window Management

| Key | Action |
|-----|--------|
| `<C-h/j/k/l>` | Navigate windows |
| `<C-w>z` | Maximize/restore window |
| `<C-w>=` | Equalize windows |
| `<leader>q` | Close buffer, keep layout |

### Git Worktree

| Key | Action |
|-----|--------|
| `<leader>wl` | List worktrees |
| `<leader>wc` | Create worktree |
| `<leader>ws` | Switch worktree |
| `<leader>wd` | Delete worktree |

### Harpoon

| Key | Action |
|-----|--------|
| `<leader>ha` | Add file to Harpoon |
| `<leader>hm` | Toggle Harpoon menu |

### Testing

| Key | Action |
|-----|--------|
| `<leader>t` | Run nearest test |
| `<leader>T` | Run test file |

### CoC (LSP)

| Key | Action |
|-----|--------|
| `<Tab>` / `<S-Tab>` | Navigate completion |
| `<CR>` | Confirm completion |
| `<C-Space>` | Trigger completion |
| `gd` | Go to definition |
| `gy` | Go to type definition |
| `gi` | Go to implementation |
| `gr` | Find references |
| `K` | Show documentation |
| `[g` / `]g` | Previous/next diagnostic |
| `<leader>rn` | Rename symbol |
| `<leader>f` | Format selection |
| `<leader>ac` | Code action |

### CoC Lists

| Key | Action |
|-----|--------|
| `<Space>a` | Show diagnostics |
| `<Space>e` | Show extensions |
| `<Space>c` | Show commands |
| `<Space>o` | Show outline |
| `<Space>s` | Show symbols |

### AI Assistants

#### CodeCompanion

| Key | Action |
|-----|--------|
| `<leader>cc` | CodeCompanion Actions |
| `<leader>ct` | Toggle Chat |
| `<leader>ca` | Add selection to Chat |

#### OpenCode

| Key | Action |
|-----|--------|
| `<leader>oa` | Ask (with context) |
| `<leader>os` | Select action |
| `<leader>op` | Prompt |
| `<leader>ot` | Toggle |
| `<leader>on` | New session |

#### Claude Code

| Key | Action |
|-----|--------|
| `<leader>ccc` | Toggle Claude Code |

### Terminal

| Key | Action |
|-----|--------|
| `<C-\>` | Toggle terminal |
| `<leader>tf` | Floating terminal |
| `<leader>tv` | Vertical terminal |
| `<leader>tt` | Vertical terminal (30%) |
| `<Esc>` | Exit terminal mode |

## LSP Configuration

### Primary: CoC

CoC handles most LSP functionality via `coc-settings.json`:

```json
{
  "graphql-lsp": {
    "module": "./node_modules/graphql-language-service-cli/bin/graphql.js",
    "filetypes": ["typescript", "typescriptreact", "graphql"],
    "initializationOptions": {
      "config": ".graphqlrc"
    }
  }
}
```

### Secondary: nvim-lspconfig

Custom YAML language server setup with SchemaStore integration:

```lua
-- Features:
-- - SchemaStore YAML schemas
-- - Custom schema support
-- - Pattern matching for specific files
```

## AI Tools Configuration

### CodeCompanion (Claude)

Uses Anthropic/Claude API for all strategies:

```lua
adapters = {
  anthropic = function()
    return require("codecompanion.adapters").extend("anthropic", {
      env = { api_key = "cmd:op read 'op://Personal/Anthropic API Key/credential'" }
    })
  end,
},
strategies = {
  chat = { adapter = "anthropic" },
  inline = { adapter = "anthropic" },
  agent = { adapter = "anthropic" },
}
```

### OpenCode

Tmux-based AI assistant:

```lua
{
  provider = "tmux",
  tmux = { args = "-h" },  -- Horizontal split
  autoread = true,
}
```

### Claude Code

Vertical split terminal integration:

```lua
window = {
  split_ratio = 0.3,
  position = "vertical",
  enter_insert = true,
}
```

## Editor Settings

```lua
-- Indentation
vim.opt.shiftwidth = 2
vim.opt.tabstop = 4
vim.opt.expandtab = true

-- Performance
vim.opt.updatetime = 300
vim.opt.redrawtime = 10000

-- Display
vim.opt.signcolumn = "yes"
vim.opt.clipboard = "unnamedplus"

-- Files
vim.opt.backup = false
vim.opt.autoread = true
vim.opt.encoding = "utf-8"
```

## Autocommands

### NERDTree

- **Auto-open**: Opens on startup if no files specified
- **Auto-close**: Closes Neovim when NERDTree is last window
- **Mirror sync**: Keeps mirrored panes in sync

### YAML/EditorConfig

- Syncs yamllint line-length with textwidth
- Respects EditorConfig settings

### Buffer Refresh

- Auto-refresh on FocusGained/BufEnter

## Adding New Plugins

1. Add to appropriate file in `lua/org/plugins/`:

```lua
-- In lua/org/plugins/core.lua (or other category)
Plug 'author/plugin-name'
```

2. Add configuration in `lua/org/plugins/config/`:

```lua
-- In lua/org/plugins/config/plugin.lua
local M = {}
function M.setup()
  require('plugin-name').setup({
    -- options
  })
end
return M
```

3. Load config from `lua/org/plugins/config/init.lua`:

```lua
require('org.plugins.config.plugin').setup()
```

4. Install:

```vim
:PlugInstall
```

## Troubleshooting

### Check Plugin Status

```vim
:PlugStatus
```

### Update Plugins

```vim
:PlugUpdate
```

### CoC Diagnostics

```vim
:CocInfo
:CocList extensions
```

### Check LSP Status

```vim
:LspInfo
```

### Debug Key Mappings

```vim
:verbose map <leader>ff
```

## Related Documentation

- [SHELL.md](SHELL.md) - Terminal/shell integration
- [TOOLS.md](TOOLS.md) - Tool configurations
- [vim-plug](https://github.com/junegunn/vim-plug) - Plugin manager
- [CoC.nvim](https://github.com/neoclide/coc.nvim) - LSP client
