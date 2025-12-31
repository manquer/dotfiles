local function register(Plug)
  Plug("tpope/vim-fugitive") -- git porcelain inside vim
  Plug("tpope/vim-rhubarb") -- github helpers for fugitive
  Plug("airblade/vim-gitgutter") -- signcolumn diff indicators
  Plug("lewis6991/gitsigns.nvim") -- lua powered git signs and actions
  Plug("f-person/git-blame.nvim") -- inline git blame virtual text
  Plug("ThePrimeagen/git-worktree.nvim") -- manage git worktrees via telescope
  Plug("pwntester/octo.nvim") -- github issue and PR management
end

return register
