vim.pack.add({
  'https://github.com/folke/lazydev.nvim',
  'https://github.com/Bilal2453/luvit-meta',
  'https://github.com/j-hui/fidget.nvim',
})

require('lazydev').setup({
  library = {
    'lazy.nvim',
    'luvit-meta/library',
    { path = 'luvit-meta/library', words = { 'vim%.uv' } },
  },
})

-- require('luvit-meta').setup({})

require('fidget').setup({
    notification = {
      override_vim_notify = false,
      window = {
        winblend = 0,
        -- border = 'rounded',
      },
    },
})
