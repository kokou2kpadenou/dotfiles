vim.pack.add({
  'https://github.com/nvim-telescope/telescope.nvim',
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/nvim-telescope/telescope-file-browser.nvim',
})

require('telescope').setup({
  defaults = {
    file_ignore_patterns = { 'node_modules', '.git' },
    color_devicons = true,
  },
})

require('telescope').load_extension('file_browser')
