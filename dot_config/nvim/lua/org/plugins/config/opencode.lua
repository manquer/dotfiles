return function()
  -- Configure opencode.nvim
  vim.g.opencode_opts = {
    provider = {
      enabled = "tmux", -- Use tmux provider
      tmux = {
        options = "-h", -- Options to pass to tmux split-window
      }
    }
  }

  -- Required for opts.events.reload
  vim.o.autoread = true

  -- Opencode keymaps (avoiding conflicts with existing keymaps)
  vim.keymap.set({ "n", "x" }, "<leader>oa", function() 
    require("opencode").ask("@this: ", { submit = true }) 
  end, { desc = "Opencode ask" })
  
  vim.keymap.set({ "n", "x" }, "<leader>os", function() 
    require("opencode").select() 
  end, { desc = "Opencode select action" })
  
  vim.keymap.set({ "n", "x" }, "<leader>op", function() 
    require("opencode").prompt("@this") 
  end, { desc = "Opencode prompt" })
  
  vim.keymap.set({ "n", "t" }, "<leader>ot", function() 
    require("opencode").toggle() 
  end, { desc = "Toggle opencode" })
  
  -- Opencode session navigation (tmux-friendly)
  vim.keymap.set("n", "<leader>ou", function() 
    require("opencode").command("session.half.page.up") 
  end, { desc = "Opencode page up" })
  
  vim.keymap.set("n", "<leader>od", function() 
    require("opencode").command("session.half.page.down") 
  end, { desc = "Opencode page down" })
  
  vim.keymap.set("n", "<leader>oi", function() 
    require("opencode").command("session.interrupt") 
  end, { desc = "Opencode interrupt" })
  
  vim.keymap.set("n", "<leader>on", function() 
    require("opencode").command("session.new") 
  end, { desc = "Opencode new session" })

  vim.g._org_opencode_config_loaded = true
end