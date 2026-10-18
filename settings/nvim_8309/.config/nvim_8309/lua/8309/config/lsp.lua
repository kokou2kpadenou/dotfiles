-- LSP Settings
---------------
vim.lsp.log.set_level 'error'       -- 'trace', 'debug', 'info', 'warn', 'error'

-- Install nvim-lspconfig
-- vim.pack.add({'https://github.com/neovim/nvim-lspconfig'})

vim.lsp.enable({
  'astro',
  'bashls',
  'cssls',
  'cssmodules_ls',
  'css_variables',
  'dockerls',
  'emmet_ls',
  'eslint',
  'gopls',
  'html',
  'jsonls',
  'lua_ls',
  -- 'intelephense',
  'pyright',
  -- 'svelte',
  'tailwindcss',
  'taplo',
  'ts_ls',
  -- 'vuels',
  'yamlls'
})
