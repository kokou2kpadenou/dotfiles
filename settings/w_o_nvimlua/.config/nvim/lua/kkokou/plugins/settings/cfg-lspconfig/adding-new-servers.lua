local lsp = require 'lspconfig'
local configs = require 'lspconfig.configs'
local util = require 'lspconfig.util'

function def_conf(name, opt)
    if not configs[name] then
        configs[name] = opt
    end
end

-- def_conf('glsl', {
--     default_config = {
--         cmd = { 'glslls', '--stdin' },
--         filetypes = { 'vert', 'tesc', 'tese', 'geom', 'frag', 'comp'},
--         root_dir = function(fname)
--             return lsp.util.find_git_ancestor(fname) or vim.loop.os_homedir()
--         end,
--         settings = {}
--     }
-- })

def_conf('astrols', {
    default_config = {
      cmd = { 'astro-ls', '--stdio' },
      filetypes = { 'astro' },
      root_dir = util.root_pattern('package.json', 'tsconfig.json', 'jsconfig.json', '.git'),
      docs = {
        description = 'https://github.com/withastro/language-tools',
        root_dir = [[root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git")]],
      },
      init_options = {
        configuration = {
          astro = {},
        },
      },
      settings = {},
    },
})
