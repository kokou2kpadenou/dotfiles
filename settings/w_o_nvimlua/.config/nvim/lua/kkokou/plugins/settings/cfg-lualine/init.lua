local lualine = require 'lualine'

local lineLists = {
  evil = require 'kkokou.plugins.settings.cfg-lualine.line-evil',
  bubbles = require 'kkokou.plugins.settings.cfg-lualine.line-bubbles',
  slanted = require 'kkokou.plugins.settings.cfg-lualine.line-slanted-gaps',
  simple = require 'kkokou.plugins.settings.cfg-lualine.line-default',
}

local default = 'evil'

lualine.setup(lineLists[default])

vim.api.nvim_create_user_command('ChangeLualine', function(opts)
  lualine.setup(lineLists[opts.args])
end, {
  nargs = 1,
  complete = function(_, _, _)
    local keyset = {}
    local n = 0

    for k, _ in pairs(lineLists) do
      n = n + 1
      keyset[n] = k
    end

    return keyset
  end,
})
