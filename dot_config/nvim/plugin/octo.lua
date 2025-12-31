if vim.g._org_octo_config_loaded then
  return
end

local ok, module = pcall(require, 'org.plugins.config.octo')
if not ok then
  vim.schedule(function()
    vim.notify(('nvim config: failed loading octo config\n%s'):format(module), vim.log.levels.WARN)
  end)
  return
end

if type(module) == 'function' then
  module()
elseif type(module) == 'table' and type(module.setup) == 'function' then
  module.setup()
end
