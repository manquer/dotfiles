local M = {}
local cli = require('org.devpod.cli')

local STATUS_HL = {
  Running  = 'DiagnosticOk',
  Stopped  = 'DiagnosticWarn',
  NotFound = 'DiagnosticError',
  Busy     = 'DiagnosticInfo',
}

local PROVIDER_REMOTE = { ssh = true, kubernetes = true, aws = true, gcp = true, azure = true }

-- "https://github.com/talview/webclients" + "develop" -> "talview/webclients@develop"
local function format_source(source)
  if not source then return '' end
  if source.gitRepository then
    local repo = source.gitRepository:match('/([^/]+/[^/]+)$') or source.gitRepository
    repo = repo:gsub('%.git$', '')
    local branch = source.gitBranch and ('@' .. source.gitBranch) or ''
    return repo .. branch
  end
  if source.localFolder then
    return vim.fn.fnamemodify(source.localFolder, ':~')
  end
  if source.image then
    return 'image:' .. source.image
  end
  return ''
end

local function relative_time(iso)
  if not iso then return '' end
  local y, mo, d, h, mn, s = iso:match('(%d+)-(%d+)-(%d+)T(%d+):(%d+):(%d+)')
  if not y then return '' end
  local t = os.time({ year = tonumber(y), month = tonumber(mo), day = tonumber(d),
                      hour = tonumber(h), min = tonumber(mn), sec = tonumber(s) })
  local diff = os.difftime(os.time(), t)
  if diff < 3600    then return math.floor(diff / 60) .. 'm'
  elseif diff < 86400   then return math.floor(diff / 3600) .. 'h'
  else return math.floor(diff / 86400) .. 'd'
  end
end

local function is_remote_provider(workspace)
  local name = workspace.provider and workspace.provider.name or ''
  return PROVIDER_REMOTE[name] == true
end

local function make_entry(ws)
  local id      = ws.id or '?'
  local source  = format_source(ws.source)
  local prov    = (ws.provider and ws.provider.name) or '?'
  local used    = relative_time(ws.lastUsed)

  local ok_disp, entry_display = pcall(require, 'telescope.pickers.entry_display')

  local display_fn
  if ok_disp then
    local displayer = entry_display.create({
      separator = '  ',
      items = {
        { width = 18 },
        { width = 42 },
        { width = 10 },
        { remaining = true },
      },
    })
    display_fn = function(_)
      return displayer({
        { id, 'TelescopeResultsIdentifier' },
        { source, 'Comment' },
        { prov, 'TelescopeResultsNumber' },
        { used, 'TelescopeResultsComment' },
      })
    end
  else
    local line = string.format('%-18s  %-42s  %-10s  %s', id, source, prov, used)
    display_fn = function(_) return line end
  end

  return {
    value   = ws,
    display = display_fn,
    ordinal = id .. ' ' .. source .. ' ' .. prov,
    -- convenience flags used by init.lua
    is_remote = is_remote_provider(ws),
  }
end

-- on_action(action, workspace) where action is one of:
--   'connect' | 'up' | 'stop' | 'delete' | 'status'
function M.open(opts, on_action)
  local ok, pickers = pcall(require, 'telescope.pickers')
  if not ok then
    vim.notify('DevPod: telescope.nvim required for picker', vim.log.levels.ERROR)
    return
  end

  local finders   = require('telescope.finders')
  local conf      = require('telescope.config').values
  local actions   = require('telescope.actions')
  local astate    = require('telescope.actions.state')
  local themes    = require('telescope.themes')

  cli.list(function(workspaces, err)
    if err then
      vim.notify('DevPod list failed: ' .. tostring(err), vim.log.levels.ERROR)
      return
    end
    if #workspaces == 0 then
      vim.notify('DevPod: no workspaces found', vim.log.levels.WARN)
      return
    end

    local picker_opts = vim.tbl_deep_extend(
      'force',
      themes.get_dropdown({ previewer = false, layout_config = { width = 0.85 } }),
      opts or {}
    )

    local function dispatch(bufnr, action)
      actions.close(bufnr)
      local sel = astate.get_selected_entry()
      if sel then on_action(action, sel.value) end
    end

    pickers.new(picker_opts, {
      prompt_title = '  DevPod  [CR]=connect  C-u=up  C-s=stop  C-x=delete  C-r=status',
      finder = finders.new_table({
        results = workspaces,
        entry_maker = make_entry,
      }),
      sorter = conf.generic_sorter(picker_opts),
      attach_mappings = function(bufnr, map)
        actions.select_default:replace(function() dispatch(bufnr, 'connect') end)
        local modes = { 'i', 'n' }
        for _, mode in ipairs(modes) do
          map(mode, '<C-u>', function() dispatch(bufnr, 'up') end)
          map(mode, '<C-s>', function() dispatch(bufnr, 'stop') end)
          map(mode, '<C-r>', function() dispatch(bufnr, 'status') end)
          map(mode, '<C-x>', function()
            local sel = astate.get_selected_entry()
            if not sel then return end
            vim.ui.select({ 'Yes', 'No' }, {
              prompt = 'Delete "' .. sel.value.id .. '"?',
            }, function(choice)
              if choice == 'Yes' then dispatch(bufnr, 'delete') end
            end)
          end)
        end
        return true
      end,
    }):find()
  end)
end

return M
