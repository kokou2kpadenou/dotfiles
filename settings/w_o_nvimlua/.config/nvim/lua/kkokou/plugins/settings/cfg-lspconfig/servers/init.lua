-- List of Defined Language Servers
return function(on_attach, capabilities)
  return {
    astro = {},
    bashls = {},
    cssls = {},
    cssmodules_ls = {},
    dockerls = {},
    emmet_ls = require 'kkokou.plugins.settings.cfg-lspconfig.servers.srv-emmet-ls'(capabilities),
    eslint = {},
    gopls = {},
    html = {},
    jsonls = require 'kkokou.plugins.settings.cfg-lspconfig.servers.srv-jsonls'(capabilities),
    sumneko_lua = require 'kkokou.plugins.settings.cfg-lspconfig.servers.srv-sumneko'(),
    tailwindcss = {},
    tsserver = require 'kkokou.plugins.settings.cfg-lspconfig.servers.srv-tsserver'(on_attach),
    yamlls = require 'kkokou.plugins.settings.cfg-lspconfig.servers.srv-yamlls'(capabilities),
  }
end
