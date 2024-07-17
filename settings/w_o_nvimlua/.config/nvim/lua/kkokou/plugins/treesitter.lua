return {
  {
    'nvim-treesitter/nvim-treesitter',
    --version = false, -- last release is way too old and doesn't work on Windows
    build = ':TSUpdate',
    dependencies = {
      'windwp/nvim-ts-autotag',
      'nvim-treesitter/nvim-treesitter-context',
    },
    event = { 'BufReadPost', 'BufNewFile' },

    opts = {
      ensure_installed = {
        'astro',
        'bash',
        'comment',
        'css',
        'dockerfile',
        'go',
        'gomod',
        'gosum',
        'gotmpl',
        'gowork',
        'html',
        'javascript',
        'jsdoc',
        'json',
        'lua',
        'markdown',
        'markdown_inline',
        'php',
        'phpdoc',
        'python',
        'scss',
        'sql',
        'svelte',
        'toml',
        'tsx',
        'typescript',
        'vue',
        'yaml',
      },

      sync_install = false,

      auto_install = true,

      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },

      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = 'gnn',
          node_incremental = 'grn',
          scope_incremental = 'grc',
          node_decremental = 'grm',
        },
      },

      indent = {
        enable = true,
      },

      autopairs = {
        enable = true,
      },
    },

    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
    end,
  },
}
