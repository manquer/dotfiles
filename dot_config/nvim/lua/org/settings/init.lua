local function load(module)
  local ok, result = pcall(require, module)
  if not ok then
    vim.schedule(function()
      vim.notify(("nvim config: settings %s failed\n%s"):format(module, result), vim.log.levels.WARN)
    end)
    return nil
  end
  return result
end

local function run(module)
  local loaded = load(module)
  if type(loaded) == "function" then
    loaded()
    return
  end
  if type(loaded) == "table" and type(loaded.setup) == "function" then
    loaded.setup()
  end
end

local M = {}

function M.setup()
  for _, module in ipairs({
    "org.settings.options",
    "org.settings.keymaps",
    "org.settings.autocmds",
  }) do
    run(module)
  end
end

return M
