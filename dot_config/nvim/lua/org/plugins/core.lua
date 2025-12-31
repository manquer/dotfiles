local function register(Plug)
  Plug("tpope/vim-sensible") -- baseline sane defaults
  Plug("editorconfig/editorconfig-vim") -- EditorConfig integration
  Plug("nvim-lua/plenary.nvim") -- lua utility helpers for many plugins
  Plug("antoinemadec/FixCursorHold.nvim") -- improve CursorHold performance
  Plug("terryma/vim-multiple-cursors") -- multi cursor editing support
  Plug("tpope/vim-surround") -- quick edit surrounding characters
  Plug("tpope/vim-repeat") -- extend repeat command to plugins
  Plug("Raimondi/delimitMate") -- auto insert matching brackets
  Plug("preservim/nerdcommenter") -- comment toggles for legacy buffers
  Plug("numToStr/Comment.nvim") -- modern commenting mappings
  Plug("godlygeek/tabular") -- text alignment motions
  Plug("tomtom/tcomment_vim") -- alternative comment motions
  Plug("Pocco81/auto-save.nvim") -- auto save buffers while editing
  Plug("MeanderingProgrammer/render-markdown.nvim") -- preview markdown with virtual text
end

return register
