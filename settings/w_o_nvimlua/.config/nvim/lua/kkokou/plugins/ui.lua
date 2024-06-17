return {
  -- Autoclose and autorename html tag using Treesitter
  {
    'windwp/nvim-ts-autotag',
    opts = {},
  },

  -- Treesitter Context
  {
    'nvim-treesitter/nvim-treesitter-context',
    opts = {},
  },

  -- This plugin adds indentation guides to all lines (including empty lines).
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = {},
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
  },
}
