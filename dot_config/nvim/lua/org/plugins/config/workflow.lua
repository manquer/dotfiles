local function with(module_name, configure)
  local ok, module = pcall(require, module_name)
  if not ok then
    return
  end
  configure(module)
end

return function()
  -- Terminal workflow
  with("toggleterm", function(plugin)
    plugin.setup({
      open_mapping = [[<c-\>]],
      close_on_exit = true,
    })

    local term_ok, terminal = pcall(require, "toggleterm.terminal")
    if term_ok then
      local float = terminal.Terminal:new({ direction = "float" })
      local vertical = terminal.Terminal:new({ direction = "vertical", size = 60 })

      vim.keymap.set("n", "<leader>tf", function()
        float:toggle()
      end, { desc = "Toggle floating terminal" })

      vim.keymap.set("n", "<leader>tv", function()
        vertical:toggle()
      end, { desc = "Toggle vertical terminal" })
    end
  end)

  -- Nx workspace automation
  with("nx", function(plugin)
    local runner_ok, runners = pcall(require, "nx.command-runners")
    local form_ok, forms = pcall(require, "nx.form-renderers")
    plugin.setup({
      nx_cmd_root = "nx",
      command_runner = runner_ok and runners.terminal_cmd() or nil,
      form_renderer = form_ok and forms.telescope() or nil,
      read_init = true,
    })
  end)

  -- Repo workflow helpers
  with("git-worktree", function(plugin)
    plugin.setup({})
    with("telescope", function(telescope)
      pcall(telescope.load_extension, "git_worktree")
    end)
  end)

  -- Quick file navigation
  with("harpoon", function(plugin)
    plugin.setup({
      menu = {
        width = 60,
      },
    })

    local ok_ui, ui = pcall(require, "harpoon.ui")
    local ok_mark, mark = pcall(require, "harpoon.mark")
    if ok_ui and ok_mark then
      vim.keymap.set("n", "<leader>ha", function()
        mark.add_file()
      end, { desc = "Add file to Harpoon list" })

      vim.keymap.set("n", "<leader>hm", function()
        ui.toggle_quick_menu()
      end, { desc = "Toggle Harpoon menu" })
    end
  end)

  -- Claude automation
  with("claude-code", function(plugin)
    if type(plugin.setup) == "function" then
      plugin.setup({
        window = {
          split_ratio = 0.3,
          position = "vertical",
          enter_insert = true,
          hide_numbers = true,
          hide_signcolumn = true,
        },
      })
    end
  end)
end
