return function()
  local function termcodes(str)
    return vim.api.nvim_replace_termcodes(str, true, false, true)
  end

  local function check_backspace()
    local col = vim.fn.col(".") - 1
    if col <= 0 then
      return true
    end
    local line = vim.api.nvim_get_current_line()
    return line:sub(col, col):match("%s") ~= nil
  end

  local function show_docs()
    if vim.fn.CocAction("hasProvider", "hover") == 1 then
      vim.fn.CocActionAsync("doHover")
    else
      vim.api.nvim_feedkeys(termcodes("K"), "in", false)
    end
  end

  -- completion navigation
  vim.keymap.set("i", "<Tab>", function()
    if vim.fn["coc#pum#visible"]() == 1 then
      return vim.fn["coc#pum#next"](1)
    end
    if check_backspace() then
      return termcodes("<Tab>")
    end
    return vim.fn["coc#refresh"]()
  end, { silent = true, expr = true, desc = "Coc completion next" })

  vim.keymap.set("i", "<S-Tab>", function()
    if vim.fn["coc#pum#visible"]() == 1 then
      return vim.fn["coc#pum#prev"](1)
    end
    return termcodes("<C-h>")
  end, { expr = true, desc = "Coc completion previous" })

  vim.keymap.set("i", "<CR>", function()
    if vim.fn["coc#pum#visible"]() == 1 then
      return vim.fn["coc#pum#confirm"]()
    end
    return termcodes("<C-g>u<CR><c-r>=coc#on_enter()<CR>")
  end, { silent = true, expr = true, desc = "Confirm Coc completion" })

  -- trigger completion
  if vim.fn.has("nvim") == 1 then
    vim.keymap.set("i", "<C-Space>", "coc#refresh()", { silent = true, expr = true, desc = "Trigger Coc completion" })
  else
    vim.keymap.set("i", "<C-@>", "coc#refresh()", { silent = true, expr = true, desc = "Trigger Coc completion" })
  end

  -- diagnostics navigation
  vim.keymap.set("n", "[g", "<Plug>(coc-diagnostic-prev)", { silent = true, remap = true, desc = "Prev diagnostic" })
  vim.keymap.set("n", "]g", "<Plug>(coc-diagnostic-next)", { silent = true, remap = true, desc = "Next diagnostic" })

  -- goto mappings
  vim.keymap.set("n", "gd", "<Plug>(coc-definition)", { silent = true, remap = true, desc = "Go to definition" })
  vim.keymap.set("n", "gy", "<Plug>(coc-type-definition)", { silent = true, remap = true, desc = "Go to type definition" })
  vim.keymap.set("n", "gi", "<Plug>(coc-implementation)", { silent = true, remap = true, desc = "Go to implementation" })
  vim.keymap.set("n", "gr", "<Plug>(coc-references)", { silent = true, remap = true, desc = "List references" })

  -- documentation popup
  vim.keymap.set("n", "K", show_docs, { silent = true, desc = "Show symbol documentation" })

  -- highlight symbol under cursor
  vim.api.nvim_create_autocmd("CursorHold", {
    callback = function()
      vim.fn.CocActionAsync("highlight")
    end,
  })

  -- formatting helpers
  vim.keymap.set("x", "<leader>f", "<Plug>(coc-format-selected)", { remap = true, desc = "Format selection" })
  vim.keymap.set("n", "<leader>f", "<Plug>(coc-format-selected)", { remap = true, desc = "Format selection" })

  -- code actions
  vim.keymap.set("x", "<leader>a", "<Plug>(coc-codeaction-selected)", { remap = true, desc = "Code action selection" })
  vim.keymap.set("n", "<leader>a", "<Plug>(coc-codeaction-selected)", { remap = true, desc = "Code action selection" })
  vim.keymap.set("n", "<leader>ac", "<Plug>(coc-codeaction-cursor)", { remap = true, desc = "Cursor code action" })
  vim.keymap.set("n", "<leader>as", "<Plug>(coc-codeaction-source)", { remap = true, desc = "Source code actions" })
  vim.keymap.set("n", "<leader>qf", "<Plug>(coc-fix-current)", { remap = true, desc = "Fix current issue" })
  vim.keymap.set("n", "<leader>re", "<Plug>(coc-codeaction-refactor)", { remap = true, desc = "Refactor code action" })
  vim.keymap.set("x", "<leader>r", "<Plug>(coc-codeaction-refactor-selected)", { remap = true, desc = "Refactor selection" })
  vim.keymap.set("n", "<leader>r", "<Plug>(coc-codeaction-refactor-selected)", { remap = true, desc = "Refactor selection" })

  -- codelens
  vim.keymap.set("n", "<leader>cl", "<Plug>(coc-codelens-action)", { remap = true, desc = "Run code lens" })

  -- text objects
  vim.keymap.set("x", "if", "<Plug>(coc-funcobj-i)", { remap = true, desc = "Inner function" })
  vim.keymap.set("o", "if", "<Plug>(coc-funcobj-i)", { remap = true, desc = "Inner function" })
  vim.keymap.set("x", "af", "<Plug>(coc-funcobj-a)", { remap = true, desc = "Around function" })
  vim.keymap.set("o", "af", "<Plug>(coc-funcobj-a)", { remap = true, desc = "Around function" })
  vim.keymap.set("x", "ic", "<Plug>(coc-classobj-i)", { remap = true, desc = "Inner class" })
  vim.keymap.set("o", "ic", "<Plug>(coc-classobj-i)", { remap = true, desc = "Inner class" })
  vim.keymap.set("x", "ac", "<Plug>(coc-classobj-a)", { remap = true, desc = "Around class" })
  vim.keymap.set("o", "ac", "<Plug>(coc-classobj-a)", { remap = true, desc = "Around class" })

  -- scroll floating windows
  local has_float_scroll = vim.fn.has("nvim-0.4.0") == 1 or vim.fn.has("patch-8.2.0750") == 1
  if has_float_scroll then
    vim.keymap.set("n", "<C-f>", function()
      if vim.fn["coc#float#has_scroll"]() == 1 then
        return vim.fn["coc#float#scroll"](1)
      end
      return termcodes("<C-f>")
    end, { silent = true, expr = true, desc = "Scroll coc float forward" })

    vim.keymap.set("n", "<C-b>", function()
      if vim.fn["coc#float#has_scroll"]() == 1 then
        return vim.fn["coc#float#scroll"](0)
      end
      return termcodes("<C-b>")
    end, { silent = true, expr = true, desc = "Scroll coc float backward" })

    vim.keymap.set("i", "<C-f>", function()
      if vim.fn["coc#float#has_scroll"]() == 1 then
        return termcodes("<c-r>=coc#float#scroll(1)<CR>")
      end
      return termcodes("<Right>")
    end, { silent = true, expr = true, desc = "Insert mode float scroll forward" })

    vim.keymap.set("i", "<C-b>", function()
      if vim.fn["coc#float#has_scroll"]() == 1 then
        return termcodes("<c-r>=coc#float#scroll(0)<CR>")
      end
      return termcodes("<Left>")
    end, { silent = true, expr = true, desc = "Insert mode float scroll backward" })

    vim.keymap.set("v", "<C-f>", function()
      if vim.fn["coc#float#has_scroll"]() == 1 then
        return vim.fn["coc#float#scroll"](1)
      end
      return termcodes("<C-f>")
    end, { silent = true, expr = true, desc = "Visual float scroll forward" })

    vim.keymap.set("v", "<C-b>", function()
      if vim.fn["coc#float#has_scroll"]() == 1 then
        return vim.fn["coc#float#scroll"](0)
      end
      return termcodes("<C-b>")
    end, { silent = true, expr = true, desc = "Visual float scroll backward" })
  end

  -- selection ranges
  vim.keymap.set({ "n", "x" }, "<C-s>", "<Plug>(coc-range-select)", { silent = true, remap = true, desc = "Coc range select" })

  -- format and fold commands
  vim.api.nvim_create_user_command("Format", function()
    vim.fn.CocActionAsync("format")
  end, {})

  vim.api.nvim_create_user_command("Fold", function(opts)
    vim.fn.CocAction("fold", table.unpack(opts.fargs))
  end, { nargs = "?" })

  vim.api.nvim_create_user_command("OR", function()
    vim.fn.CocActionAsync("runCommand", "editor.action.organizeImport")
  end, {})

  -- coc list helpers
  local coc_list = {
    a = "diagnostics",
    e = "extensions",
    c = "commands",
    o = "outline",
    s = "-I symbols",
  }

  for key, target in pairs(coc_list) do
    vim.keymap.set("n", "<Space>" .. key, ":<C-u>CocList " .. target .. "<CR>", { silent = true, nowait = true, desc = "Coc list " .. target })
  end

  vim.keymap.set("n", "<Space>j", ":<C-u>CocNext<CR>", { silent = true, nowait = true, desc = "Coc next item" })
  vim.keymap.set("n", "<Space>k", ":<C-u>CocPrev<CR>", { silent = true, nowait = true, desc = "Coc previous item" })
  vim.keymap.set("n", "<Space>p", ":<C-u>CocListResume<CR>", { silent = true, nowait = true, desc = "Coc list resume" })

  -- set formatexpr for select filetypes
  local group = vim.api.nvim_create_augroup("TalviewCocFormats", { clear = true })
  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = { "typescript", "json" },
    callback = function()
      vim.bo.formatexpr = "CocAction('formatSelected')"
    end,
  })
end
