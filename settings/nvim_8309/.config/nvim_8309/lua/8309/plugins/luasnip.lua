vim.pack.add({
  { src = 'https://github.com/L3MON4D3/LuaSnip', version = vim.version.range('>=2.0') },
  {
    src = "https://github.com/rafamadriz/friendly-snippets",
  },
})

local ls = require("luasnip")
local types = require 'luasnip.util.types'

vim.keymap.set({ "i" }, "<C-K>", function() ls.expand() end, { silent = true })
vim.keymap.set({ "i", "s" }, "<tab>", function() ls.jump(1) end, { silent = true })
vim.keymap.set({ "i", "s" }, "<s-tab>", function() ls.jump(-1) end, { silent = true })

vim.keymap.set({ "i", "s" }, "<C-E>", function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end, { silent = true })


ls.setup({
  history = true,
  updateevents = 'TextChanged,TextChangedI',
  delete_check_events = 'TextChanged',
  ext_opts = {
    [types.choiceNode] = {
      active = {
        virt_text = { { '●', 'DiagnosticError' } },
      },
    },
    [types.insertNode] = {
      active = {
        virt_text = { { '●', 'DiagnosticHint' } },
      },
    },
  },
  ext_base_prio = 300,
  enable_autosnippets = true,
  ft_func = function()
    return vim.split(vim.bo.filetype, '.', { plain = true, trimempty = true })
  end,
})

-- Load friendly-snippets
require('luasnip.loaders.from_vscode').lazy_load {
  -- paths = { vim.fn.stdpath 'data' .. '/site/pack/packer/start/friendly-snippets' },
}

ls.filetype_extend('javascript', { 'javascriptreact' })
ls.filetype_extend('typescript', { 'typescriptreact' })
