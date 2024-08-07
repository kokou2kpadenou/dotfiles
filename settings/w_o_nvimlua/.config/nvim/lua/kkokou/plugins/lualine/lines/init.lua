local lualine = require 'lualine'
local some_funcs = require 'kkokou.utils.unofficial'
local excludeWins =
  { '', 'netrw', 'checkhealth', 'packer', 'help', 'undotree', 'diff', 'dbui', 'dbout', 'qf', 'neo-tree' }
local defConfig = vim.g.kkokou_lualine_lines
--
local function ShowWinbar(response)
  lualine.hide {
    place = { 'winbar' },
    unhide = response,
  }
end

local function winbarToggleSplit()
  if some_funcs.detect_win_split() then
    ShowWinbar(true)
    return
  end

  ShowWinbar(false)
end

-- local function get_lualine_cfg(cfglist, cfgname)
local function get_lualine_cfg(cfgname)
  -- Proprety common to all the configs
  local base_config = {
    options = {
      theme = 'auto',
      disabled_filetypes = {
        statusline = {},
        winbar = excludeWins,
      },
      globalstatus = true,
    },
    winbar = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = { { 'filename', path = 1 } },
    },

    inactive_winbar = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = { { 'filename', path = 1 } },
    },
    -- extensions = { 'fugitive', 'quickfix' },
  }

  return vim.tbl_deep_extend('force', base_config, require('kkokou.plugins.lualine.lines.line-' .. cfgname))
end

vim.api.nvim_create_user_command('LualineChange', function(opts)
  local cfg_selected = opts.args ~= '' and opts.args or 'evil'

  -- disable lualine
  if cfg_selected == 'disable' then
    -- vim.g.kkokou_lualine_disable = true
    pcall(lualine.hide, {
      place = { 'statusline', 'tabline', 'winbar' },
      unhide = false,
    })
    return
  end

  if some_funcs.has_value(defConfig, cfg_selected) then
    pcall(ShowWinbar, false)

    lualine.setup(get_lualine_cfg(cfg_selected))
    winbarToggleSplit()
  else
    print 'Unknow lualine configuration name'
  end
end, {
  nargs = '?',
  complete = function(argLead, _, _)
    local configList = defConfig

    local return_config = { 'disable' }

    for _, v in ipairs(configList) do
      table.insert(return_config, v)
    end

    -- Auto Complete
    local i = 1
    while i <= #return_config do
      if not some_funcs.start_with(argLead, return_config[i]) then
        table.remove(return_config, i)
        -- do not increment the index here, retry the same element
      else
        i = i + 1
      end
    end

    table.sort(return_config)
    return return_config
  end,
})

local autoActiveWinBar = vim.api.nvim_create_augroup('AutoActiveWinBar', { clear = true })

-- TODO: Fix cases when event buffer close the winbar still visible. Or exclude some buffer like Neotree, UndoList
vim.api.nvim_create_autocmd({
  'BufEnter',
  'BufDelete', --[[ , 'ColorScheme' ]]
  'ColorScheme',
  'BufLeave',
}, {
  group = autoActiveWinBar,

  callback = function()
    local winsplitstate = some_funcs.detect_win_split()
    -- If window is floating, do nothing
    if some_funcs.is_floating(0) then
      return
    end

    if not winsplitstate then
      ShowWinbar(false)
      return
    end

    if winsplitstate and vim.o.winbar ~= '' then
      -- winbar is already actived.
      return
    end

    if winsplitstate then
      ShowWinbar(true)
    end
  end,
})

-- TODO: Not working for now
if not vim.g.kkokou_lualine_disable then
  vim.cmd { cmd = 'LualineChange', args = { vim.g.kkokou_lualine_config_name } }
end
