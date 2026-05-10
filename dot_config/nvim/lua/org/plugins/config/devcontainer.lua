return function()
  require("devcontainer").setup({
    terminal_handler = function(cmd)
      vim.cmd("botright split")
      vim.cmd("terminal " .. cmd)
    end,
    log_level = "info",
  })
end
