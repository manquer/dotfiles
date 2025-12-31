return function()
  -- windows.nvim configuration
  vim.o.winwidth = 10
  vim.o.winminwidth = 10
  vim.o.equalalways = false
  require('windows').setup()
  
  -- windows.nvim keymaps
  local function cmd(command)
    return table.concat({ '<Cmd>', command, '<CR>' })
  end
  
  vim.keymap.set('n', '<C-w>z', cmd 'WindowsMaximize', { desc = "Windows: Maximize/restore window" })
  vim.keymap.set('n', '<C-w>_', cmd 'WindowsMaximizeVertically', { desc = "Windows: Maximize vertically" })
  vim.keymap.set('n', '<C-w>|', cmd 'WindowsMaximizeHorizontally', { desc = "Windows: Maximize horizontally" })
  vim.keymap.set('n', '<C-w>=', cmd 'WindowsEqualize', { desc = "Windows: Equalize all windows" })
end