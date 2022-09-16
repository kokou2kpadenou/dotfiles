-- Diagnostic Settings
----------------------
vim.diagnostic.config {
  virtual_text = false,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded' },
}

-- Change diagnostic symbols in the sign column (gutter)
local signs = { Error = ' ', Warn = ' ', Hint = ' ', Info = ' ' }
for type, icon in pairs(signs) do
  local hl = 'DiagnosticSign' .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Diagnostic keymaps
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)

-- LSP Settings
---------------
local lspconfig = require 'lspconfig'

vim.lsp.set_log_level 'error' -- 'trace', 'debug', 'info', 'warn', 'error'

local on_attach = function(_, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f', vim.lsp.buf.format, bufopts)

end

-- nvim-cmp supports additional completion capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

local default_lsp_config = {
  on_attach = on_attach,
  capabilities = capabilities,
  flags = {
    debounce_text_changes = 200,
    allow_incremental_sync = true,
  },
}

-- IMPORTANT: make sure to setup lua-dev BEFORE lspconfig for sumneko_lua
require("lua-dev").setup({
  -- add any options here, or leave empty to use the default settings
})

-- Enable the following language servers
local servers = {
  astro = {},
  bashls = {},
  cssls = {},
  cssmodules_ls = {},
  dockerls = {},
  --[[ efm = require 'kkokou.plugins.settings.cfg-lspconfig.servers.srv-efm' (), ]]
  emmet_ls = require 'kkokou.plugins.settings.cfg-lspconfig.servers.srv-emmet-ls' (capabilities),
  eslint = {},
  gopls = {},
  html = {},
  jsonls = require 'kkokou.plugins.settings.cfg-lspconfig.servers.srv-jsonls' (capabilities),
  sumneko_lua = require 'kkokou.plugins.settings.cfg-lspconfig.servers.srv-sumneko' (),
  tailwindcss = {},
  tsserver = require 'kkokou.plugins.settings.cfg-lspconfig.servers.srv-tsserver' (on_attach),
  yamlls = require 'kkokou.plugins.settings.cfg-lspconfig.servers.srv-yamlls' (capabilities),
}

for lsp, lsp_config in pairs(servers) do
  local merged_config = vim.tbl_deep_extend('force', default_lsp_config, lsp_config)

  lspconfig[lsp].setup(merged_config)
end

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' })
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' })
