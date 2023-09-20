-- List of Defined Language Servers
return function(on_attach, capabilities)
  return {
    astro = require 'kkokou.plugins.lsp.servers.srv-astro'(),
    bashls = {},
    cssls = {},
    cssmodules_ls = {},
    dockerls = {},
    emmet_ls = require 'kkokou.plugins.lsp.servers.srv-emmet-ls' (capabilities),
    eslint = {},
    gopls = require 'kkokou.plugins.lsp.servers.srv-gopls'(),
    html = {},
    jsonls = require 'kkokou.plugins.lsp.servers.srv-jsonls' (capabilities),
    lua_ls = require 'kkokou.plugins.lsp.servers.srv-lua_ls' (),
    intelephense = {},
    pyright = {},
    -- sqlls = {},
    svelte = {},
    tailwindcss = {},
    tsserver = require 'kkokou.plugins.lsp.servers.srv-tsserver' (on_attach),
    vuels = {},
    yamlls = require 'kkokou.plugins.lsp.servers.srv-yamlls' (capabilities),
  }
end
