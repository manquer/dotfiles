return function()
  local had_stdin = false

  local function update_yamllint_line_length(bufnr)
    local ok, ft = pcall(vim.api.nvim_buf_get_option, bufnr, "filetype")
    if not ok or ft ~= "yaml" then
      return
    end

    local textwidth = vim.api.nvim_buf_get_option(bufnr, "textwidth")
    if textwidth > 0 then
      local line_length_rule = string.format(
        "-d '{extends: default, rules: {line-length: {max: %d}}}'",
        textwidth
      )
      pcall(vim.api.nvim_buf_set_var, bufnr, "ale_yaml_yamllint_options", line_length_rule)
    else
      pcall(vim.api.nvim_buf_del_var, bufnr, "ale_yaml_yamllint_options")
    end
  end

  -- track whether stdin fed the current session
  vim.api.nvim_create_autocmd("StdinReadPre", {
    callback = function()
      had_stdin = true
    end,
  })

  -- open nerdtree when starting without files
  vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
      if vim.fn.argc() == 0 and not had_stdin then
        vim.cmd("NERDTree")
      end
    end,
  })

  -- close neovim if nerdtree is the last remaining window
  vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
      if vim.fn.tabpagenr("$") == 1 and vim.fn.winnr("$") == 1 and vim.b.NERDTree and vim.b.NERDTree.isTabTree then
        vim.cmd("quit")
      end
    end,
  })

  -- keep mirrored nerdtree panes in sync
  vim.api.nvim_create_autocmd("BufWinEnter", {
    callback = function()
      if vim.fn.getcmdwintype() ~= "" then
        return
      end

      if vim.bo.buftype ~= "" then
        return
      end

      if vim.fn.exists(":NERDTreeMirror") == 2 then
        pcall(vim.cmd, "silent! NERDTreeMirror")
      end
    end,
  })

  -- auto refresh buffers visible in windows
  vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
    callback = function()
      if vim.api.nvim_get_mode().mode ~= "c" then
        vim.cmd("checktime")
      end
    end,
  })

  -- keep yamllint line-length in sync with textwidth/editorconfig
  vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
    pattern = { "*.yaml", "*.yml" },
    callback = function(event)
      vim.schedule(function()
        update_yamllint_line_length(event.buf)
      end)
    end,
  })

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "yaml",
    callback = function(event)
      update_yamllint_line_length(event.buf)
    end,
  })

  vim.api.nvim_create_autocmd("OptionSet", {
    pattern = "textwidth",
    callback = function(event)
      local buf = event.buf or vim.api.nvim_get_current_buf()
      update_yamllint_line_length(buf)
    end,
  })
end
