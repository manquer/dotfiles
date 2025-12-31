local function register(Plug)
  Plug("nvim-treesitter/nvim-treesitter", { ["do"] = ":TSUpdate" }) -- modern syntax tree highlighting
  Plug("neoclide/coc.nvim", { branch = "release" }) -- language server protocol client
  Plug("neovim/nvim-lspconfig") -- quickstart configs for built-in lsp
  Plug("b0o/schemastore.nvim") -- json schema catalog for lspconfig
  Plug("dense-analysis/ale") -- asynchronous linting engine
  Plug("jparise/vim-graphql") -- graphql syntax support
  Plug("kevinhwang91/promise-async") -- async primitives for ufo and others
  Plug("kevinhwang91/nvim-ufo") -- advanced folding powered by lsp
  Plug("folke/trouble.nvim") -- diagnostics and quickfix viewer
  Plug("smjonas/inc-rename.nvim") -- incremental rename ui
  Plug("ThePrimeagen/refactoring.nvim") -- refactoring helpers using treesitter
  Plug("Equilibris/nx.nvim") -- nx workspace developer ergonomics
  Plug("greggh/claude-code.nvim") -- claude workflow integration
end

return register
