return function()
  -- Setup catppuccin with default options
  require("catppuccin").setup()
  
  local ok, err = pcall(vim.cmd, "colorscheme catppuccin")
  if not ok then
    vim.notify("Failed to load catppuccin: " .. err, vim.log.levels.ERROR)
  end
  
  -- Disable ColorColumn highlight for nightfox
 -- if vim.g.colors_name == "nightfox" then
    vim.cmd("highlight clear ColorColumn")
--  end
end
