local function with(module_name, configure)
  local ok, module = pcall(require, module_name)
  if not ok then
    return
  end
  configure(module)
end

return function()
  with("codecompanion", function(plugin)
    plugin.setup({
      strategies = {
        chat = {
          adapter = "anthropic",
        },
        inline = {
          adapter = "anthropic",
        },
        agent = {
          adapter = "anthropic",
        },
      },
    })

    -- Keymaps for codecompanion
    vim.keymap.set({ "n", "v" }, "<leader>cc", "<cmd>CodeCompanionActions<cr>", { desc = "CodeCompanion Actions" })
    vim.keymap.set({ "n", "v" }, "<leader>ct", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "Toggle CodeCompanion Chat" })
    vim.keymap.set("v", "<leader>ca", "<cmd>CodeCompanionChat Add<cr>", { desc = "Add to CodeCompanion Chat" })
  end)
end
