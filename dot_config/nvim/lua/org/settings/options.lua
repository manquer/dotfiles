return function()
  -- editor defaults
  vim.opt.shiftwidth = 2
  vim.opt.smarttab = true
  vim.opt.expandtab = true
  vim.opt.tabstop = 4
  vim.opt.softtabstop = 0
  vim.g.mapleader = ","

  -- files and updates
  vim.opt.encoding = "utf-8"
  vim.opt.backup = false
  vim.opt.writebackup = false
  vim.opt.updatetime = 300
  vim.opt.signcolumn = "yes"
  vim.opt.autoread = true
  vim.opt.redrawtime = 10000  -- Increase redraw timeout for large repos (default: 2000ms)
  

  -- statusline integration with coc
  vim.cmd([[set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}]])

  -- display
  vim.opt.colorcolumn = ""
  vim.cmd("highlight clear ColorColumn")

  -- clipboard
  vim.opt.clipboard = "unnamedplus"
  
  -- Set pbcopy/pbpaste as clipboard provider for macOS
  vim.g.clipboard = {
    name = 'pbcopy',
    copy = {
      ['+'] = 'pbcopy',
      ['*'] = 'pbcopy',
    },
    paste = {
      ['+'] = 'pbpaste',
      ['*'] = 'pbpaste',
    },
    cache_enabled = 0,
  }

  -- plugin globals
  vim.g.gitblame_enabled = 1
end