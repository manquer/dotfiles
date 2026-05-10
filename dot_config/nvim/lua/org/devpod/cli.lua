local M = {}

-- Run devpod async. cb(ok: bool, stdout: string, stderr: string)
-- --silent suppresses devpod's log-file output when run non-interactively
function M.run(args, cb)
  vim.system(
    vim.list_extend({ 'devpod', '--silent' }, args),
    { text = true },
    function(result)
      vim.schedule(function()
        cb(result.code == 0, result.stdout or '', result.stderr or '')
      end)
    end
  )
end

-- Run devpod in a new terminal split (for commands with meaningful output like `up`)
function M.run_in_terminal(args)
  local parts = { 'devpod' }
  for _, a in ipairs(args) do
    table.insert(parts, vim.fn.shellescape(a))
  end
  vim.cmd('botright split | terminal ' .. table.concat(parts, ' '))
  vim.cmd('startinsert')
end

function M.list(cb)
  M.run({ 'list', '--output', 'json' }, function(ok, stdout, stderr)
    if not ok then
      cb(nil, stderr ~= '' and stderr or stdout)
      return
    end
    -- devpod may route JSON to stderr in non-TTY environments
    local raw = stdout ~= '' and stdout or stderr
    local success, data = pcall(vim.json.decode, raw)
    if not success then
      cb(nil, 'json parse error — got: ' .. raw:sub(1, 200))
      return
    end
    cb(data or {}, nil)
  end)
end

-- devpod status --output json returns {id, state, context}
-- state values: Running, Stopped, NotFound, Busy
function M.status(name, cb)
  M.run({ 'status', name, '--output', 'json' }, function(ok, stdout, stderr)
    if not ok then
      cb(nil, stderr ~= '' and stderr or stdout)
      return
    end
    local raw = stdout ~= '' and stdout or stderr
    local success, data = pcall(vim.json.decode, raw)
    cb(success and data or nil, success and nil or 'json parse error — got: ' .. raw:sub(1, 200))
  end)
end

function M.stop(name, cb)
  M.run({ 'stop', name }, function(ok, _, stderr)
    if cb then cb(ok, stderr) end
  end)
end

function M.delete(name, cb)
  M.run({ 'delete', name, '--force' }, function(ok, _, stderr)
    if cb then cb(ok, stderr) end
  end)
end

return M
