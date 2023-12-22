return {
  -- Visualizes undo history and makes it easier to browse and switch between different undo branches
  { 'mbbill/undotree', cmd = 'UndotreeToggle' },

  -- Surroundings
  {
    'kylechui/nvim-surround',
    -- event = 'VeryLazy',
    config = true,
  },

  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    -- context_commentstring = {
    --   enable = true,
    --   enable_autocmd = false,
    -- },
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

  -- Interaction with Databases
  {
    'kristijanhusak/vim-dadbod-ui',
    cmd = { 'DBUI', 'DBUIAddConnection', 'DBUIToggle' },
    dependencies = { 'tpope/vim-dadbod', 'kristijanhusak/vim-dadbod-completion', 'hrsh7th/nvim-cmp' },
    config = function()
      vim.g.db_ui_save_location = '~/Documents/.database/db_ui'
      vim.g.db_ui_win_position = 'right'
      vim.g.db_ui_show_database_icon = '1'
      vim.g.db_ui_use_nerd_fonts = '1'
      vim.g.db_ui_icons = {
        expanded = {
          db = '▾ ',
          buffers = '▾ ',
          saved_queries = '▾ ',
          schemas = '▾ ',
          schema = '▾ 󱏒',
          tables = '▾ ',
          table = '▾ ',
        },
        collapsed = {
          db = '▸ ',
          buffers = '▸ ',
          saved_queries = '▸ ',
          schemas = '▸ ',
          schema = '▸ 󱏒',
          tables = '▸ ',
          table = '▸ ',
        },
        saved_query = '󰈖',
        new_query = '󰝒',
        tables = '',
        buffers = '﬘',
        add_connection = '󱘖',
        connection_ok = '✓',
        connection_error = '✕',
      }

      local function enable_completion()
        ---@diagnostic disable-next-line: missing-fields
        require('cmp').setup.buffer { sources = { { name = 'vim-dadbod-completion' } } }
      end

      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'sql', 'mysql', 'plsql' },
        callback = enable_completion,
      })
    end,
  },
}
