return {

  -- Status Line
  {
    'nvim-lualine/lualine.nvim',
    cmd = 'ChangeLualine',
    dependencies = { 'nvim-tree/nvim-web-devicons', 'Exafunction/codeium.vim' },
    config = function()
      require 'kkokou.plugins.lualine.lines'
    end,
  },
}
