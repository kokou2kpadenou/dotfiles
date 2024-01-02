return {
  -- Autoclose and autorename html tag using Treesitter
  {
    'windwp/nvim-ts-autotag',
    -- event = 'VeryLazy',
    opts = {
      filetypes = {
        'html',
        'javascript',
        'typescript',
        'javascriptreact',
        'typescriptreact',
        'svelte',
        'vue',
        'tsx',
        'jsx',
        'rescript',
        'xml',
        'php',
        'markdown',
        'glimmer',
        'handlebars',
        'hbs',
        'astro',
      },
    },
    config = true,
  },

  -- Treesitter Context
  {
    'nvim-treesitter/nvim-treesitter-context',
    -- event = 'VeryLazy',
    opts = {},
    config = true,
  },

  -- This plugin adds indentation guides to all lines (including empty lines).
  {
    'lukas-reineke/indent-blankline.nvim',
    main = "ibl",
    opts = {},
    config = true,
  },

  -- Color highlighter for Neovim
  {
    'brenoprata10/nvim-highlight-colors',
    event = { 'BufReadPost', 'BufNewFile' },
    ft = {
      'html',
      'css',
      'scss',
      'astro',
      'vue',
      'svelte',
      'javascript',
      'javascriptreact',
      'typescript',
      'typescriptreact',
    },
    opts = {
      render = 'background', -- or 'foreground' or 'first_column'
      enable_named_colors = true,
      enable_tailwind = true,
    },
    config = true,
  },

  -- neo-tree.nvim
  {
    'nvim-neo-tree/neo-tree.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
      'MunifTanjim/nui.nvim',
    },
    cmd = 'Neotree',
  },
}
