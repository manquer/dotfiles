local function safe_require(module)
  local ok, result = pcall(require, module)
  if not ok then
    vim.schedule(function()
      vim.notify(("nvim config: failed loading %s\n%s"):format(module, result), vim.log.levels.WARN)
    end)
    return nil
  end
  return result
end

local M = {}

function M.setup()
  safe_require("org.plugins").setup()
  safe_require("org.settings").setup()
  safe_require("org.plugins.config").setup()
end

return M
