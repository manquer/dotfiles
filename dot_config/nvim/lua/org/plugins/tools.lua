local function register(Plug)
  Plug("tpope/vim-dispatch") -- async build and test dispatcher
  Plug("vim-test/vim-test") -- language agnostic test runner
  Plug("preservim/vimux") -- tmux pane integration for test commands
  Plug("nvim-neotest/nvim-nio") -- async wrappers used by testing plugins
  Plug("andythigpen/nvim-coverage") -- code coverage visualisation
  Plug("olimorris/codecompanion.nvim") -- AI coding assistant
  Plug("NickvanDyke/opencode.nvim") -- opencode AI assistant
end

return register
