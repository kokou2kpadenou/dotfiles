return {

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
