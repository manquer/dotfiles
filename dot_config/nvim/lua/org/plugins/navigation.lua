local function register(Plug)
  Plug("preservim/nerdtree") -- filesystem explorer tree
  Plug("Xuyuanp/nerdtree-git-plugin") -- git decorations for NERDTree
  Plug("tiagofumo/vim-nerdtree-syntax-highlight") -- improved NERDTree highlight groups
  Plug("justinmk/vim-sneak") -- two-character jump motions
  Plug("pechorin/any-jump.vim") -- jump to symbol implementations
  Plug("majutsushi/tagbar") -- outline sidebar for tags
  Plug("junegunn/fzf", { ["do"] = ":call fzf#install()" }) -- fuzzy finder binary install
  Plug("nvim-telescope/telescope.nvim", { tag = "0.1.8" }) -- picker powered by telescope
  Plug("ThePrimeagen/harpoon") -- quick file mark navigation
end

return register
