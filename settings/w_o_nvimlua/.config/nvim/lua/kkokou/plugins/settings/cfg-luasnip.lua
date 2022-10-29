local ls = require 'luasnip'
local types = require 'luasnip.util.types'

ls.config.set_config {
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
}

-- Load friendly-snippets
require('luasnip.loaders.from_vscode').lazy_load {
  paths = { vim.fn.stdpath 'data' .. '/site/pack/packer/start/friendly-snippets' },
}

ls.filetype_extend('javascript', { 'javascriptreact' })
ls.filetype_extend('typescript', { 'typescriptreact' })

-- Mapping
vim.cmd [[
  " press <Tab> to expand or jump in a snippet. These can also be mapped separately
  " via <Plug>luasnip-expand-snippet and <Plug>luasnip-jump-next.
  imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>'
  " -1 for jumping backwards.
  inoremap <silent> <S-Tab> <cmd>lua require'luasnip'.jump(-1)<Cr>

  snoremap <silent> <Tab> <cmd>lua require('luasnip').jump(1)<Cr>
  snoremap <silent> <S-Tab> <cmd>lua require('luasnip').jump(-1)<Cr>

  " For changing choices in choiceNodes (not strictly necessary for a basic setup).
  imap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'
  smap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'
]]
