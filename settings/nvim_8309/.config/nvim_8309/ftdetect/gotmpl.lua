vim.api.nvim_create_autocmd({
  'BufNewFile',
  'BufRead',
}, {
  pattern = '*.yaml,*.yml,*.html,*.gotmpl,*.gotexttmpl,*.gohtmltmpl,*.gotext,*.gohtml',
  callback = function()
    if vim.fn.search('{{.\\+}}', 'nw') ~= 0 then
      vim.api.nvim_set_option_value('filetype', 'gotmpl', { buf = 0 })
    end
  end,
})
