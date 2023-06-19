local lualine = require 'lualine'
local some_funcs = require 'kkokou.utils.unofficial'
local excludeWins = { '', 'netrw', 'checkhealth', 'packer', 'help', 'undotree', 'diff', 'dbui', 'qf', 'neo-tree' }
local defConfig = { 'evil', 'bubbles', 'slanted-gaps', 'default' }
--
local function ShowWinbar()
  lualine.hide {
    place = { 'winbar' },
    unhide = true,
  }
end

local function HideWinbar()
  lualine.hide {
    place = { 'winbar' },
  }
end

local function winbarToggleSplit()
  if some_funcs.detect_win_split() then
    ShowWinbar()
    return
  end

  HideWinbar()
end
--
local cfg_selected = some_funcs.has_value(defConfig, vim.g.lualineConfigName) and vim.g.lualineConfigName or 'evil'

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

  return vim.tbl_deep_extend('force', base_config, require('kkokou.settings.cfg-lualine.line-' .. cfgname))
end

lualine.setup(get_lualine_cfg(cfg_selected))
winbarToggleSplit()

-- FIXME: Stranges characters appear in the lualine after CahngeLualine executed
vim.api.nvim_create_user_command('ChangeLualine', function(opts)
  -- disable lualine

  cfg_selected = opts.args

  if some_funcs.has_value(defConfig, cfg_selected) then
    lualine.hide {}

    lualine.setup(get_lualine_cfg(cfg_selected))
    winbarToggleSplit()
  else
    print 'Unknow configuration name'
  end
  -- lualine.setup(get_lualine_cfg(cfg_selected))

  -- winbarToggleSplit()
end, {
  nargs = 1,
  complete = function(argLead, _, _)
    local configList = { 'evil', 'bubbles', 'slanted-gaps', 'default' }

    local return_config = configList

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

-- TODO: Add event BufDelete
-- take care of neovim reload and other things
--
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufDelete' }, {
  group = autoActiveWinBar,

  callback = function()
    local winsplitstate = some_funcs.detect_win_split()
    -- If window is floating, do nothing
    if some_funcs.is_floating(0) then
      return
    end

    if not winsplitstate then
      HideWinbar()
      return
    end

    if winsplitstate and vim.o.winbar ~= '' then
      -- winbar is already actived.
      return
    end

    ShowWinbar()
  end,
})
