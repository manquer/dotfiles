local function with(module_name, configure)
  local ok, module = pcall(require, module_name)
  if not ok then
    return
  end
  configure(module)
end

return function()
  with("auto-save", function(plugin)
    plugin.setup({
      debounce_delay = 60000, -- delay in milliseconds (60 seconds)
    })
  end)

  with("refactoring", function(plugin)
    plugin.setup()
  end)

  with("inc_rename", function(plugin)
    plugin.setup()
    vim.keymap.set("n", "<leader>rn", function()
      return ":IncRename " .. vim.fn.expand("<cword>")
    end, { expr = true, desc = "Rename symbol with inc-rename" })
  end)

  with("Comment", function(plugin)
    plugin.setup()
  end)

  with("render-markdown", function(plugin)
    plugin.setup({})
  end)
end
