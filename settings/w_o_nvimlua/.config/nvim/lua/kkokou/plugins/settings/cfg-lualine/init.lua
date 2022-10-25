local lualine = require 'lualine'
local winfn = require 'kkokou.utils.winfn'
local excludeWins = { 'netrw', 'checkhealth', 'packer', 'help', 'undotree', 'diff', 'dbui', 'qf', 'fugitive', 'git' }
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
  if winfn.detect_win_split() then
    print 'did we come where?'
    ShowWinbar()
    return
  end

  HideWinbar()
end
--
local configList = { 'evil', 'bubbles', 'slanted-gaps', 'defaut' }

local cfg_selected = 'evil'

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
    extensions = { 'fugitive', 'quickfix' },
  }

  return vim.tbl_deep_extend('force', base_config, require('kkokou.plugins.settings.cfg-lualine.line-' .. cfgname))
end

lualine.setup(get_lualine_cfg(cfg_selected))

winbarToggleSplit()

vim.api.nvim_create_user_command('ChangeLualine', function(opts)
  -- disable lualine
  lualine.hide {}

  cfg_selected = opts.args
  lualine.setup(get_lualine_cfg(cfg_selected))

  winbarToggleSplit()
end, {
  nargs = 1,
  complete = function (_, _, _)
      -- TODO: filter and sort the args
    return configList
  end
})

local autoActiveWinBar = vim.api.nvim_create_augroup('AutoActiveWinBar', { clear = true })

vim.api.nvim_create_autocmd({ 'WinEnter' }, {
  group = autoActiveWinBar,

  callback = function()
    local winsplitstate = winfn.detect_win_split()
    -- If window is floating, do nothing
    if winfn.is_floating(0) then
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
