return function()
  local ok, remote = pcall(require, "remote-nvim")
  if not ok then return end
  remote.setup()
end
