return function()
  local ok, notify = pcall(require, "notify")
  if not ok then return end
  notify.setup({
    timeout = 3000,
    render = "compact",
    stages = "fade",
  })
  vim.notify = notify
end
