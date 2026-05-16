return function()
  local ok, remote = pcall(require, "remote-nvim")
  if not ok then return end

  remote.setup({
    -- Copy plugins alongside config so the remote env works OOB
    remote = {
      copy_dirs = {
        config = {
          base = vim.fn.stdpath("config"),
          dirs = "*",
          compression = { enabled = true },
        },
        data = {
          base = vim.fn.stdpath("data"),
          dirs = { "plugged" }, -- vim-plug installs here
          compression = { enabled = true },
        },
      },
    },
    -- Skip GitHub version checks — use whatever neovim is already cached/installed
    offline_mode = {
      enabled = true,
      no_github = false,
    },
  })
end
