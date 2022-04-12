require('null-ls').setup {
  debug = true,
  log = {
    enable = true,
    level = 'warn',
    use_console = 'async',
  },
  sources = {
    require('null-ls').builtins.formatting.prettierd.with {
      filetypes = {
        'javascript',
        'javascriptreact',
        'typescript',
        'typescriptreact',
        'vue',
        'css',
        'scss',
        'less',
        'html',
        'json',
        'jsonc',
        'yaml',
        'markdown',
        'graphql',
        'handlebars',
        'astro',
      },
    },
  },
}
