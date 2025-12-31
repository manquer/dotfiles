local function with(module_name, configure)
  local ok, module = pcall(require, module_name)
  if not ok then
    return
  end
  configure(module)
end

return function()
  with("coverage", function(plugin)
    plugin.setup({
      commands = true,
      highlights = {
        covered = { fg = "#C3E88D" },
        uncovered = { fg = "#F07178" },
      },
      signs = {
        covered = { hl = "CoverageCovered", text = "▎" },
        uncovered = { hl = "CoverageUncovered", text = "▎" },
      },
      summary = {
        min_coverage = 80.0,
      },
    })
  end)

  with("trouble", function(plugin)
    plugin.setup({
      opts = {},
      cmd = "Trouble",
    })
  end)

  with("ufo", function(plugin)
    plugin.setup()
    vim.o.foldcolumn = "1"
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true
  end)
end
