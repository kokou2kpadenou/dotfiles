return {
  {
    'nvim-treesitter/nvim-treesitter',
    --version = false, -- last release is way too old and doesn't work on Windows
    build = ':TSUpdate',
    dependencies = {
      'JoosepAlviste/nvim-ts-context-commentstring', -- Dynamically set commentstring based on cursor location in file
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
        'html',
        'javascript',
        'jsdoc',
        'json',
        'lua',
        'markdown',
        'markdown_inline',
        'python',
        'scss',
        'svelte',
        'toml',
        'tsx',
        'vue',
        'typescript',
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

      context_commentstring = {
        enable = true,
        enable_autocmd = false,
      },
    },

    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
    end,
  },
}