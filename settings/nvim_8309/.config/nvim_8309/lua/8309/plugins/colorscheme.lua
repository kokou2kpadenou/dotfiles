vim.pack.add({
  {
    src = 'https://github.com/folke/tokyonight.nvim',
  }
})

require('tokyonight').setup({
  style = 'storm',
  transparent = true,
  terminal_colors = true,
  styles = {
    sidebars = 'transparent',
    floats = 'transparent',
  },
  on_colors = function()
  end,
  on_highlights = function()
  end
})

vim.api.nvim_cmd({ cmd = 'colorscheme', args = { 'tokyonight' } }, {})
