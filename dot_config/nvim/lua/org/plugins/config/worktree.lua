local ok, worktree = pcall(require, "git-worktree")
if not ok then
  return
end

local ok_telescope, telescope = pcall(require, "telescope")
if not ok_telescope then
  return
end

-- Setup git-worktree
worktree.setup({
  change_directory_command = "cd",
  update_on_change = true,
  update_on_change_command = "e .",
  clearjumps_on_change = true,
  autopush = false,
})

-- Load telescope extension
telescope.load_extension("git_worktree")
