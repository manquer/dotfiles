return function()
  -- Black Metal (Burzum) base16 scheme, matching the ghostty terminal theme
  local ok, err = pcall(vim.cmd, "colorscheme base16-black-metal-burzum")
  if not ok then
    vim.notify("Failed to load base16-black-metal-burzum: " .. err, vim.log.levels.ERROR)
  end

  vim.cmd("highlight clear ColorColumn")
end
