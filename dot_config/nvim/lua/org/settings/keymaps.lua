return function()
  local map = vim.keymap.set

  -- buffer lifecycle
  map("n", "<leader>q", ":bp<CR>:bd #<CR>", { silent = true, desc = "Close current buffer but keep layout" })

  -- testing shortcuts
  map("n", "<leader>t", ":TestNearest<CR>", { silent = true, desc = "Run nearest test" })
  map("n", "<leader>T", ":TestFile<CR>", { silent = true, desc = "Run test file" })
  map("n", "<leader>tt", function()
    vim.cmd('rightbelow vsplit')
    vim.cmd('vertical resize ' .. math.floor(vim.o.columns * 0.3))
    vim.cmd('terminal')
    vim.cmd('startinsert')
  end, { silent = true, desc = "Open vertical terminal (30% width)" })

  -- terminal navigation
  map("t", "<Esc>", [[<C-\><C-n>]], { silent = true, desc = "Leave terminal mode" })
  map("t", "<C-h>", [[<C-\><C-n><C-w>h]], { silent = true, desc = "Terminal focus left split" })
  map("t", "<C-j>", [[<C-\><C-n><C-w>j]], { silent = true, desc = "Terminal focus below split" })
  map("t", "<C-k>", [[<C-\><C-n><C-w>k]], { silent = true, desc = "Terminal focus upper split" })
  map("t", "<C-l>", [[<C-\><C-n><C-w>l]], { silent = true, desc = "Terminal focus right split" })

  -- window focus helpers
  map("n", "<C-h>", "<C-w>h", { silent = true, desc = "Focus left window" })
  map("n", "<C-l>", "<C-w>l", { silent = true, desc = "Focus right window" })

  -- tagbar toggle
  map("n", "<F8>", ":TagbarToggle<CR>", { silent = true, desc = "Toggle Tagbar outline" })

  -- telescope pickers
  map("n", "<leader>ff", "<Cmd>Telescope find_files<CR>", { silent = true, desc = "Find files" })
  map("n", "<leader>fg", "<Cmd>Telescope live_grep<CR>", { silent = true, desc = "Live grep" })
  map("n", "<leader>fb", "<Cmd>Telescope buffers<CR>", { silent = true, desc = "List buffers" })
  map("n", "<leader>fh", "<Cmd>Telescope help_tags<CR>", { silent = true, desc = "Help tags" })

  -- git worktree
  map("n", "<leader>wl", "<Cmd>lua require('telescope').extensions.git_worktree.git_worktrees()<CR>", { silent = true, desc = "List git worktrees" })
  map("n", "<leader>wc", "<Cmd>lua require('telescope').extensions.git_worktree.create_git_worktree()<CR>", { silent = true, desc = "Create git worktree" })
  map("n", "<leader>ws", "<Cmd>lua require('telescope').extensions.git_worktree.git_worktrees()<CR>", { silent = true, desc = "Switch git worktree" })
  map("n", "<leader>wd", "<Cmd>lua require('telescope').extensions.git_worktree.git_worktrees()<CR>", { silent = true, desc = "Delete git worktree" })

  -- ALE diagnostics
  map("n", "<C-k>", "<Plug>(ale_previous_wrap)", { silent = true, remap = true, desc = "ALE previous diagnostic" })
  map("n", "<C-j>", "<Plug>(ale_next_wrap)", { silent = true, remap = true, desc = "ALE next diagnostic" })

  -- sneak motions
  map({ "n", "x", "o" }, "f", "<Plug>Sneak_f", { remap = true, desc = "Sneak forward char" })
  map({ "n", "x", "o" }, "F", "<Plug>Sneak_F", { remap = true, desc = "Sneak backward char" })
  map({ "n", "x", "o" }, "t", "<Plug>Sneak_t", { remap = true, desc = "Sneak before char" })
  map({ "n", "x", "o" }, "T", "<Plug>Sneak_T", { remap = true, desc = "Sneak after char" })

  -- barbar bufferline
  map("n", "<A-,>", "<Cmd>BufferPrevious<CR>", { silent = true, desc = "Previous buffer" })
  map("n", "<A-.>", "<Cmd>BufferNext<CR>", { silent = true, desc = "Next buffer" })
  map("n", "<A-<>", "<Cmd>BufferMovePrevious<CR>", { silent = true, desc = "Move buffer left" })
  map("n", "<A->>", "<Cmd>BufferMoveNext<CR>", { silent = true, desc = "Move buffer right" })
  map("n", "<A-1>", "<Cmd>BufferGoto 1<CR>", { silent = true, desc = "Go to buffer 1" })
  map("n", "<A-2>", "<Cmd>BufferGoto 2<CR>", { silent = true, desc = "Go to buffer 2" })
  map("n", "<A-3>", "<Cmd>BufferGoto 3<CR>", { silent = true, desc = "Go to buffer 3" })
  map("n", "<A-4>", "<Cmd>BufferGoto 4<CR>", { silent = true, desc = "Go to buffer 4" })
  map("n", "<A-5>", "<Cmd>BufferGoto 5<CR>", { silent = true, desc = "Go to buffer 5" })
  map("n", "<A-6>", "<Cmd>BufferGoto 6<CR>", { silent = true, desc = "Go to buffer 6" })
  map("n", "<A-7>", "<Cmd>BufferGoto 7<CR>", { silent = true, desc = "Go to buffer 7" })
  map("n", "<A-8>", "<Cmd>BufferGoto 8<CR>", { silent = true, desc = "Go to buffer 8" })
  map("n", "<A-9>", "<Cmd>BufferGoto 9<CR>", { silent = true, desc = "Go to buffer 9" })
  map("n", "<A-0>", "<Cmd>BufferLast<CR>", { silent = true, desc = "Go to last buffer" })
  map("n", "<A-p>", "<Cmd>BufferPin<CR>", { silent = true, desc = "Toggle buffer pin" })
  map("n", "<A-c>", "<Cmd>BufferClose<CR>", { silent = true, desc = "Close buffer" })
  map("n", "<A-s-c>", "<Cmd>BufferRestore<CR>", { silent = true, desc = "Restore buffer" })
  map("n", "<C-p>", "<Cmd>BufferPick<CR>", { silent = true, desc = "Pick buffer" })
  map("n", "<C-S-p>", "<Cmd>BufferPickDelete<CR>", { silent = true, desc = "Pick buffer to delete" })
  map("n", "<Space>bb", "<Cmd>BufferOrderByBufferNumber<CR>", { silent = true, desc = "Order buffers by number" })
  map("n", "<Space>bn", "<Cmd>BufferOrderByName<CR>", { silent = true, desc = "Order buffers by name" })
  map("n", "<Space>bd", "<Cmd>BufferOrderByDirectory<CR>", { silent = true, desc = "Order buffers by directory" })
  map("n", "<Space>bl", "<Cmd>BufferOrderByLanguage<CR>", { silent = true, desc = "Order buffers by language" })
  map("n", "<Space>bw", "<Cmd>BufferOrderByWindowNumber<CR>", { silent = true, desc = "Order buffers by window" })

 -- claude code
 map("n", "<leader>ccc", "<cmd>ClaudeCode<CR>", { desc = 'Toggle Claude Code' })

end
