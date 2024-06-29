return {
  -- Visualizes undo history and makes it easier to browse and switch between different undo branches
  { 'mbbill/undotree', cmd = 'UndotreeToggle' },

  -- Surroundings
  {
    'kylechui/nvim-surround',
    event = 'VeryLazy',
    config = function()
      require('nvim-surround').setup {}
    end,
  },

  {
    'JoosepAlviste/nvim-ts-context-commentstring',
  },

  -- Comment text in and out
  {
    'numToStr/Comment.nvim',
    dependencies = { 'JoosepAlviste/nvim-ts-context-commentstring' },
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('Comment').setup {
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
      }
    end,
  },

  -- todo comments
  {
    'folke/todo-comments.nvim',
    cmd = { 'TodoTelescope', 'TodoLocList', 'TodoQuickFix' },
    event = { 'BufReadPost', 'BufNewFile' },
    config = true,
    -- stylua= ignore
    keys = {
      {
        ']t',
        function()
          require('todo-comments').jump_next()
        end,
        desc = 'Next todo comment',
      },
      {
        '[t',
        function()
          require('todo-comments').jump_prev()
        end,
        desc = 'Previous todo comment',
      },
      { '<leader>xt', '<cmd>TodoTrouble<cr>', desc = 'Todo (Trouble)' },
      { '<leader>xT', '<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>', desc = 'Todo/Fix/Fixme (Trouble)' },
      { '<leader>st', '<cmd>TodoTelescope<cr>', desc = 'Todo' },
    },
  },
}
