local M = {}

local function register_group(Plug, register)
  if type(register) ~= "function" then
    return
  end
  register(Plug)
end

function M.setup()
  local Plug = vim.fn["plug#"]

  vim.call("plug#begin")

  local groups = {
    require("org.plugins.core"),
    require("org.plugins.ui"),
    require("org.plugins.navigation"),
    require("org.plugins.git"),
    require("org.plugins.lsp"),
    require("org.plugins.tools"),
  }

  for _, group in ipairs(groups) do
    register_group(Plug, group)
  end

  vim.call("plug#end")
end

return M
