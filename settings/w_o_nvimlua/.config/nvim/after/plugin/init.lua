-- Activate global statusline
vim.o.laststatus = 3

vim.o.winbar = '%=%m %f'

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'netrw', 'checkhealth', 'packer', 'help' },
  command = 'setlocal winbar=%=%y',
})
