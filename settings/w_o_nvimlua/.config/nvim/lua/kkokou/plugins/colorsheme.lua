return {
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    opts = {
      style = 'storm',
      transparent = true,
      terminal_colors = true,
      styles = {
        sidebars = 'transparent',
        floats = 'transparent',
      },
    },
    config = function(_, opts)
      require('tokyonight').setup(opts)

      -- load the colorscheme here
      vim.api.nvim_cmd({ cmd = 'colorscheme', args = { 'tokyonight' } }, {})
    end,
  },

  -- Catppuccin
  {
    'catppuccin/nvim',
    lazy = true,
    name = 'catppuccin',
    opts = {
      transparent_background = true,
    },
  },

  -- Bluloco
  {
    'uloco/bluloco.nvim',
    lazy = true,
    name = 'bluloco',
    dependencies = { 'rktjmp/lush.nvim' },
    opts = {
      style = 'dark',
      transparent = true,
      italics = true,
    },
  },
}
