-- List of Defined Language Servers
return function(on_attach, capabilities)
  return {
    astro = {
      init_options = {
        configuration = {},
        typescript = {
          serverPath = vim.fs.normalize '~/.local/share/pnpm/global/5/node_modules/typescript/lib/tsserverlibrary.js',
        },
      },
    },
    bashls = {},
    cssls = {},
    cssmodules_ls = {},
    dockerls = {},
    emmet_ls = require 'kkokou.settings.cfg-lspconfig.servers.srv-emmet-ls'(capabilities),
    eslint = {},
    gopls = {},
    html = {},
    jsonls = require 'kkokou.settings.cfg-lspconfig.servers.srv-jsonls'(capabilities),
    lua_ls = require 'kkokou.settings.cfg-lspconfig.servers.srv-lua_ls'(),
    pyright = {},
    svelte = {},
    tailwindcss = {},
    tsserver = require 'kkokou.settings.cfg-lspconfig.servers.srv-tsserver'(on_attach),
    vuels = {},
    yamlls = require 'kkokou.settings.cfg-lspconfig.servers.srv-yamlls'(capabilities),
  }
end
