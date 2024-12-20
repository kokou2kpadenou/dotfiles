-- List of Defined Language Servers
return function(capabilities)
  return {
    astro = require 'kkokou.plugins.lsp.servers.srv-astro'(),
    bashls = {},
    cssls = {},
    cssmodules_ls = {},
    dockerls = {},
    emmet_ls = require 'kkokou.plugins.lsp.servers.srv-emmet-ls'(capabilities),
    eslint = {},
    gopls = require 'kkokou.plugins.lsp.servers.srv-gopls'(),
    html = {},
    jsonls = require 'kkokou.plugins.lsp.servers.srv-jsonls'(capabilities),
    lua_ls = require 'kkokou.plugins.lsp.servers.srv-lua_ls'(),
    intelephense = {},
    pyright = {},
    svelte = {},
    tailwindcss = require 'kkokou.plugins.lsp.servers.srv-tailwindcss'(),
    -- taplo = require('kkokou.plugins.lsp.servers.srv-taplo')(capabilities),
    ts_ls = require 'kkokou.plugins.lsp.servers.srv-tsls'(),
    vuels = {},
    yamlls = require 'kkokou.plugins.lsp.servers.srv-yamlls'(capabilities),
  }
end
