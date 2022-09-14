vim.g.db_ui_save_location = '~/Documents/.database/db_ui'

local function enable_completion()
  require('cmp').setup.buffer { sources = { { name = 'vim-dadbod-completion' } } }
end

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'sql', 'mysql', 'plsql' },
  callback = enable_completion,
})
