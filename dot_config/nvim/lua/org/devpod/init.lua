local M = {}
local cli    = require('org.devpod.cli')
local picker = require('org.devpod.picker')


-- devpod containers use devpod-specific labels, not standard devcontainer labels,
-- so DevcontainerAttach cannot find them. Always connect via devpod ssh.
local function connect(workspace)
  vim.cmd('botright split')
  vim.cmd('terminal devpod ssh ' .. vim.fn.shellescape(workspace.id))
  vim.cmd('startinsert')
end

local function handle_action(action, workspace)
  local name = workspace.id

  if action == 'connect' then
    connect(workspace)

  elseif action == 'up' then
    -- Show in terminal: devpod up can take minutes and has rich output
    cli.run_in_terminal({ 'up', name })

  elseif action == 'stop' then
    vim.notify('DevPod: stopping ' .. name .. ' …', vim.log.levels.INFO)
    cli.stop(name, function(ok, err)
      if ok then
        vim.notify('DevPod: ' .. name .. ' stopped', vim.log.levels.INFO)
      else
        vim.notify('DevPod: stop failed — ' .. tostring(err), vim.log.levels.ERROR)
      end
    end)

  elseif action == 'delete' then
    vim.notify('DevPod: deleting ' .. name .. ' …', vim.log.levels.INFO)
    cli.delete(name, function(ok, err)
      if ok then
        vim.notify('DevPod: ' .. name .. ' deleted', vim.log.levels.INFO)
      else
        vim.notify('DevPod: delete failed — ' .. tostring(err), vim.log.levels.ERROR)
      end
    end)

  elseif action == 'status' then
    cli.status(name, function(data, err)
      if err or not data then
        vim.notify('DevPod: status error — ' .. tostring(err), vim.log.levels.ERROR)
        return
      end
      local state = data.state or data.status or 'Unknown'
      vim.notify(string.format('DevPod: %s  →  %s', name, state), vim.log.levels.INFO)
    end)
  end
end

-- Open one tab per running workspace, each attached to its tmux session via devpod ssh.
-- Invariant: at most one tmux session per pod, so `tmux attach || tmux` is sufficient.
local function load_all_running()
  cli.list(function(workspaces, err)
    if err or not workspaces then
      vim.notify('list failed — ' .. tostring(err), vim.log.levels.ERROR, { title = 'DevPod' })
      return
    end
    if #workspaces == 0 then
      vim.notify('no workspaces found', vim.log.levels.WARN, { title = 'DevPod' })
      return
    end

    local notif = vim.notify(
      string.format('checking %d workspace(s)…', #workspaces),
      vim.log.levels.INFO,
      { title = 'DevPod', timeout = false }
    )

    local pending = #workspaces
    local running = {}
    for _, ws in ipairs(workspaces) do
      cli.status(ws.id, function(data, _)
        if data and data.state == 'Running' then
          table.insert(running, ws.id)
        end
        pending = pending - 1
        if pending == 0 then
          if #running == 0 then
            vim.notify('no running workspaces', vim.log.levels.WARN, {
              title = 'DevPod', replace = notif,
            })
            return
          end
          table.sort(running)
          for _, name in ipairs(running) do
            vim.cmd('noautocmd tabnew')
            vim.cmd(table.concat({
              'noautocmd terminal devpod ssh',
              vim.fn.shellescape(name),
              '--command',
              vim.fn.shellescape('tmux attach || tmux'),
            }, ' '))
            pcall(vim.api.nvim_buf_set_name, 0, 'devpod://' .. name)
            vim.cmd('startinsert')
          end
          vim.notify(
            string.format('opened %d workspace(s)', #running),
            vim.log.levels.INFO,
            { title = 'DevPod', replace = notif }
          )
        end
      end)
    end
  end)
end

-- Open picker with an action forced (used by commands that accept an optional name arg).
-- If name is given, run action directly; otherwise open picker and use workspace selection.
local function with_name_or_pick(name, action, direct_fn)
  if name and name ~= '' then
    direct_fn(name)
    return
  end
  picker.open({}, function(_, workspace)
    if action then
      handle_action(action, workspace)
    else
      direct_fn(workspace.id, workspace)
    end
  end)
end

function M.setup()
  if vim.fn.executable('devpod') == 0 then
    vim.notify('DevPod: binary not found in PATH', vim.log.levels.WARN)
    return
  end

  -- :DevpodList — open picker (all actions available inside)
  vim.api.nvim_create_user_command('DevpodList', function()
    picker.open({}, handle_action)
  end, { desc = 'List DevPod workspaces' })

  -- :DevpodLoadAll — open one tab per running workspace, each attached to its tmux session
  vim.api.nvim_create_user_command('DevpodLoadAll', function()
    load_all_running()
  end, { desc = 'Open all running DevPod workspaces in tabs (tmux attach)' })

  -- :DevpodUp [name] — start workspace, show output in terminal
  vim.api.nvim_create_user_command('DevpodUp', function(o)
    with_name_or_pick(o.args, nil, function(name)
      cli.run_in_terminal({ 'up', name })
    end)
  end, { nargs = '?', desc = 'Start a DevPod workspace' })

  -- :DevpodStop [name]
  vim.api.nvim_create_user_command('DevpodStop', function(o)
    with_name_or_pick(o.args, 'stop', function(name)
      vim.notify('DevPod: stopping ' .. name .. ' …', vim.log.levels.INFO)
      cli.stop(name, function(ok, err)
        local msg = ok and (name .. ' stopped') or ('stop failed — ' .. tostring(err))
        vim.notify('DevPod: ' .. msg, ok and vim.log.levels.INFO or vim.log.levels.ERROR)
      end)
    end)
  end, { nargs = '?', desc = 'Stop a DevPod workspace' })

  -- :DevpodConnect [name] — connect (devcontainer or SSH)
  vim.api.nvim_create_user_command('DevpodConnect', function(o)
    with_name_or_pick(o.args, nil, function(_, workspace)
      -- when called with a name only, we don't have the full workspace object;
      -- build a minimal one so connect() can still route correctly
      if workspace then
        connect(workspace)
      else
        -- name-only path: fall back to SSH (no provider info available)
        vim.cmd('botright split')
        vim.cmd('terminal devpod ssh ' .. vim.fn.shellescape(o.args))
        vim.cmd('startinsert')
      end
    end)
  end, { nargs = '?', desc = 'Connect to a DevPod workspace' })

  -- :DevpodDelete [name]
  vim.api.nvim_create_user_command('DevpodDelete', function(o)
    with_name_or_pick(o.args, nil, function(name)
      vim.ui.select({ 'Yes', 'No' }, {
        prompt = 'Delete workspace "' .. name .. '"?',
      }, function(choice)
        if choice ~= 'Yes' then return end
        vim.notify('DevPod: deleting ' .. name .. ' …', vim.log.levels.INFO)
        cli.delete(name, function(ok, err)
          local msg = ok and (name .. ' deleted') or ('delete failed — ' .. tostring(err))
          vim.notify('DevPod: ' .. msg, ok and vim.log.levels.INFO or vim.log.levels.ERROR)
        end)
      end)
    end)
  end, { nargs = '?', desc = 'Delete a DevPod workspace' })

  -- :DevpodStatus [name]
  vim.api.nvim_create_user_command('DevpodStatus', function(o)
    with_name_or_pick(o.args, 'status', function(name)
      cli.status(name, function(data, err)
        if err or not data then
          vim.notify('DevPod: status error — ' .. tostring(err), vim.log.levels.ERROR)
          return
        end
        local state = data.state or data.status or 'Unknown'
        vim.notify(string.format('DevPod: %s  →  %s', name, state), vim.log.levels.INFO)
      end)
    end)
  end, { nargs = '?', desc = 'Show status of a DevPod workspace' })
end

return M
