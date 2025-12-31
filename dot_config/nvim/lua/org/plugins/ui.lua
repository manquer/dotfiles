local function register(Plug)
  Plug("vim-airline/vim-airline") -- lean statusline with rich sections
  Plug("catppuccin/nvim", { as = "catppuccin" }) -- catppuccin theme collection
--  Plug("EdenEast/nightfox.nvim") -- nightfox theme variants
  Plug("preservim/vim-indent-guides") -- visualize indentation levels
  Plug("nvim-tree/nvim-web-devicons") -- filetype icons for statuslines
  Plug("romgrk/barbar.nvim") -- tabline style buffer tabs
  Plug("akinsho/toggleterm.nvim", { tag = "*" }) -- floating terminal integration
  Plug("edluffy/hologram.nvim") -- image previews inside Neovim

  -- windows.nvim dependencies
  Plug("anuvyklack/middleclass") -- dependency for windows.nvim
  Plug("anuvyklack/animation.nvim") -- optional animations for windows.nvim
  Plug("anuvyklack/windows.nvim") -- window management with animations
end

return register
