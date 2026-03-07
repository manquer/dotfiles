# Keybindings Cheat Sheet

Leader key: `,` (nvim) | `,` sequences (zed)

## Navigation

| Binding | Action | Nvim | Zed |
|---|---|---|---|
| `, f f` | Find files | Telescope find_files | file_finder::Toggle |
| `, f g` | Live grep / project search | Telescope live_grep | pane::DeploySearch |
| `, f b` | List open buffers/tabs | Telescope buffers | tab_switcher::Toggle |
| `, f h` | Help tags | Telescope help_tags | - |
| `Ctrl-p` | Pick buffer/tab | BufferPick | tab_switcher::Toggle |
| `, e` | Toggle file tree | - | workspace::ToggleLeftDock |
| `F8` | Toggle outline/tagbar | TagbarToggle | outline::Toggle |
| `g d` | Go to definition | (vim default) | (vim default) |
| `g D` | Go to declaration | - | (vim default) |
| `g y` | Go to type definition | - | (vim default) |
| `g I` | Go to implementation | - | (vim default) |
| `g A` | All references | - | (vim default) |
| `g s` | Symbol in file | - | (vim default) |
| `g S` | Symbol in project | - | (vim default) |

## Buffer / Tab Management

| Binding | Action | Nvim | Zed |
|---|---|---|---|
| `Alt-,` | Previous buffer/tab | BufferPrevious | pane::ActivatePreviousItem |
| `Alt-.` | Next buffer/tab | BufferNext | pane::ActivateNextItem |
| `Alt-<` | Move buffer left | BufferMovePrevious | - |
| `Alt->` | Move buffer right | BufferMoveNext | - |
| `Alt-1..9` | Go to buffer/tab 1-9 | BufferGoto N | pane::ActivateItem N |
| `Alt-0` | Go to last buffer/tab | BufferLast | pane::ActivateLastItem |
| `Alt-p` | Pin buffer | BufferPin | - |
| `Alt-c` | Close buffer/tab | BufferClose | pane::CloseActiveItem |
| `Alt-S-c` | Restore closed buffer | BufferRestore | - |
| `Ctrl-S-p` | Pick buffer to delete | BufferPickDelete | - |
| `, q` | Close buffer keep layout | bp + bd # | pane::CloseActiveItem |
| `Space b b` | Order by buffer number | BufferOrderByBufferNumber | - |
| `Space b n` | Order by name | BufferOrderByName | - |
| `Space b d` | Order by directory | BufferOrderByDirectory | - |
| `Space b l` | Order by language | BufferOrderByLanguage | - |
| `Space b w` | Order by window | BufferOrderByWindowNumber | - |

## Window / Split Management

| Binding | Action | Nvim | Zed |
|---|---|---|---|
| `Ctrl-h` | Focus left split/pane | `<C-w>h` | workspace::ActivatePaneLeft |
| `Ctrl-l` | Focus right split/pane | `<C-w>l` | workspace::ActivatePaneRight |
| `Ctrl-w z` | Maximize/restore window | WindowsMaximize | workspace::ToggleZoom |
| `Ctrl-w _` | Maximize vertically | WindowsMaximizeVertically | - |
| `Ctrl-w \|` | Maximize horizontally | WindowsMaximizeHorizontally | - |
| `Ctrl-w =` | Equalize windows | WindowsEqualize | (vim default) |

## Diagnostics

| Binding | Action | Nvim | Zed |
|---|---|---|---|
| `Ctrl-j` | Next diagnostic | ALE next_wrap | editor::GoToDiagnostic |
| `Ctrl-k` | Previous diagnostic | ALE previous_wrap | editor::GoToPreviousDiagnostic |
| `g ]` | Next diagnostic | - | (vim default) |
| `g [` | Previous diagnostic | - | (vim default) |
| `g h` | Show inline error | - | (vim default) |
| `g .` | Code actions | - | (vim default) |

## Motions

| Binding | Action | Nvim | Zed |
|---|---|---|---|
| `f` / `F` | Sneak forward/backward char | vim-sneak | (vim default) |
| `t` / `T` | Sneak before/after char | vim-sneak | (vim default) |
| `s` / `S` | Two-char sneak forward/backward | vim-sneak | vim::PushSneak / PushSneakBackward |

## Editing

| Binding | Action | Nvim | Zed |
|---|---|---|---|
| `, r n` | Rename symbol | IncRename | editor::Rename |
| `g c` / `g c c` | Toggle comment | Comment.nvim | (vim default) |
| `y s` | Add surround | (vim default) | (vim default) |
| `c s` | Change surround | (vim default) | (vim default) |
| `d s` | Delete surround | (vim default) | (vim default) |

## Git

| Binding | Action | Nvim | Zed |
|---|---|---|---|
| `] c` | Next git hunk | gitgutter | (vim default) |
| `[ c` | Previous git hunk | gitgutter | (vim default) |
| `d o` | Expand diff hunk | - | (vim default) |
| `d p` | Restore/revert hunk | - | (vim default) |
| `, w l` | List git worktrees | git-worktree (telescope) | - |
| `, w c` | Create git worktree | git-worktree (telescope) | - |
| `, w s` | Switch git worktree | git-worktree (telescope) | - |

## Terminal

| Binding | Action | Nvim | Zed |
|---|---|---|---|
| `Ctrl-\` | Toggle terminal | toggleterm | terminal_panel::ToggleFocus |
| `, t f` | Toggle floating/bottom terminal | toggleterm float | workspace::ToggleBottomDock |
| `, t v` | Toggle vertical/right terminal | toggleterm vertical | workspace::ToggleRightDock |
| `, t t` | Open terminal split | vertical terminal | workspace::ToggleBottomDock |
| `Escape` | Leave terminal mode (nvim) | `<C-\><C-n>` | - |
| `Ctrl-h/j/k/l` | Navigate from terminal to splits | `<C-\><C-n><C-w>` | workspace::ActivatePane* |

## Harpoon (nvim only)

| Binding | Action |
|---|---|
| `, h a` | Add file to harpoon list |
| `, h m` | Toggle harpoon menu |

## Testing (nvim only)

| Binding | Action |
|---|---|
| `, t` | Run nearest test |
| `, T` | Run test file |

## Project Panel (Zed, NERDTree-style)

| Binding | Action |
|---|---|
| `h` / `l` | Collapse / expand folder |
| `j` / `k` | Navigate up / down |
| `o` / `Enter` | Open file |
| `a` | New file |
| `Shift-a` | New directory |
| `r` | Rename |
| `d` | Delete |
| `x` / `y` / `p` | Cut / copy / paste |
| `Escape` | Close panel |

## Insert Mode

| Binding | Action | Nvim | Zed |
|---|---|---|---|
| `j k` | Escape to normal mode | - | vim::NormalBefore |

## Multi-cursor (Zed vim)

| Binding | Action |
|---|---|
| `g l` | Add next word match |
| `g L` | Add previous word match |
| `g a` | Select all word matches |
| `g >` | Skip latest, add next |
| `g <` | Skip latest, add previous |

## Other

| Binding | Action | Nvim |
|---|---|---|
| `, c c c` | Toggle Claude Code | ClaudeCode |
