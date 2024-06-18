vim.api.nvim_create_autocmd({
  'BufNewFile',
  'BufRead',
}, {
  pattern = '*.yaml,*.yml,*.html',
  callback = function()
    if vim.fn.search('{{.\\+}}', 'nw') ~= 0 then
      -- local buf = vim.api.nvim_get_current_buf()
      vim.api.nvim_set_option_value('filetype', 'gotmpl', { buf = 0 })
    end
  end,
})
