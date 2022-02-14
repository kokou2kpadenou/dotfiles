--
vim.lsp.set_log_level 'error' -- 'trace', 'debug', 'info', 'warn', 'error'

-- Diagnostic keymaps
vim.api.nvim_set_keymap(
  'n',
  '<leader>e',
  '<cmd>lua vim.diagnostic.open_float({ border = "rounded" })<CR>',
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  'n',
  '[d',
  '<cmd>lua vim.diagnostic.goto_prev({ float = { border = "rounded" }})<CR>',
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  'n',
  ']d',
  '<cmd>lua vim.diagnostic.goto_next({ float = { border = "rounded" }})<CR>',
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap('n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', { noremap = true, silent = true })

-- LSP settings
local lspconfig = require 'lspconfig'

local on_attach = function(_, bufnr)
  local opts = { noremap = true, silent = true }
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(
    bufnr,
    'n',
    '<leader>wl',
    '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>',
    opts
  )
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(
    bufnr,
    'n',
    '<leader>so',
    [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]],
    opts
  )
  vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting()' ]]
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
-- local servers = { 'jsonls', 'cssls', 'html', 'tailwindcss', 'gopls', 'bashls' }

local servers = {
  -- dockerls = {},
  bashls = {},
  cssls = {},
  efm = require("kkokou.plugins.settings.cfg-lspconfig.servers.srv-efm")(),
  eslint = {},
  gopls = {},
  html = {},
  jsonls = require 'kkokou.plugins.settings.cfg-lspconfig.servers.srv-jsonls'(capabilities),
  sumneko_lua = require 'kkokou.plugins.settings.cfg-lspconfig.servers.srv-sumneko'(),
  tailwindcss = {},
  tsserver = require 'kkokou.plugins.settings.cfg-lspconfig.servers.srv-tsserver'(on_attach),
  yamlls = require("kkokou.plugins.settings.cfg-lspconfig.servers.srv-yamlls")(capabilities),
}

for lsp, lsp_config in pairs(servers) do
  local merged_config = vim.tbl_deep_extend('force', default_lsp_config, lsp_config)

  lspconfig[lsp].setup(merged_config)
end

-- Change diagnostic symbols in the sign column (gutter)
local signs = { Error = ' ', Warn = ' ', Hint = ' ', Info = ' ' }
for type, icon in pairs(signs) do
  local hl = 'DiagnosticSign' .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- LSP Enable diagnostics
vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  virtual_text = false,
  underline = true,
  signs = true,
  update_in_insert = false,
  severity_sort = true,
  -- float = {
  -- 	focus = false,
  -- 	focusable = false,
  -- 	style = "minimal",
  -- 	border = "rounded",
  -- 	source = "always",
  -- 	header = "",
  -- 	prefix = "",
  -- },
})

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' })
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' })
