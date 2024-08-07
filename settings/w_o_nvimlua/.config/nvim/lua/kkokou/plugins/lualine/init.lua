return {
  {
    'nvim-lualine/lualine.nvim',
    cmd = 'LualineChange',
    -- TODO: lazy load the plugin only when the lualine is disabled

    -- cmd = function ()
    --   if vim.g.kkokou_lualine_disable then
    --     return {'LualineChange'}
    --   end
    -- end,
    dependencies = { 'nvim-tree/nvim-web-devicons', 'Exafunction/codeium.vim' },
    config = function()
      require 'kkokou.plugins.lualine.lines'
    end,
    init = function()
      -- Indicate if the lualine display or not
      vim.g.kkokou_lualine_disable = true
      -- The default configuration at start
      vim.g.kkokou_lualine_config_name = 'default'
      -- lualine lines
      vim.g.kkokou_lualine_lines = { 'evil', 'bubbles', 'slanted-gaps', 'default' }
    end,
  },
}
