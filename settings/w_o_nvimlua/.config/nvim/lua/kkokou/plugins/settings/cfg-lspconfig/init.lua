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
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- LSP Settings
---------------
local lspconfig = require 'lspconfig'

vim.lsp.set_log_level 'error' -- 'trace', 'debug', 'info', 'warn', 'error'

local on_attach = function(_, bufnr)
  local opts = { buffer = bufnr }

  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
  vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
  vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
  vim.keymap.set('n', '<leader>wl', function()
    vim.inspect(vim.lsp.buf.list_workspace_folders())
  end, opts)
  vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', '<leader>so', require('telescope.builtin').lsp_document_symbols, opts) -- )

  vim.api.nvim_create_user_command('Format', vim.lsp.buf.format, {})
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

-- Enable the following language servers
local servers = {
  astro = {},
  bashls = {},
  cssls = {},
  dockerls = {},
  efm = require 'kkokou.plugins.settings.cfg-lspconfig.servers.srv-efm'(),
  eslint = {},
  gopls = {},
  html = {},
  jsonls = require 'kkokou.plugins.settings.cfg-lspconfig.servers.srv-jsonls'(capabilities),
  sumneko_lua = require 'kkokou.plugins.settings.cfg-lspconfig.servers.srv-sumneko'(),
  -- tailwindcss = {},
  tsserver = require 'kkokou.plugins.settings.cfg-lspconfig.servers.srv-tsserver'(on_attach),
  yamlls = require 'kkokou.plugins.settings.cfg-lspconfig.servers.srv-yamlls'(capabilities),
}

for lsp, lsp_config in pairs(servers) do
  local merged_config = vim.tbl_deep_extend('force', default_lsp_config, lsp_config)

  lspconfig[lsp].setup(merged_config)
end

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' })
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' })
