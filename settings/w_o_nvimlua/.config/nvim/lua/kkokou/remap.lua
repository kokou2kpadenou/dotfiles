-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

vim.keymap.set('n', 'J', 'mzJ`z')

vim.keymap.set('x', '<leader>p', '"_dP')

vim.keymap.set('n', '<leader>x', '<cmd>!chmod +x %<CR>', { silent = true })

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ 'n', 'v' }, '<leader>y', [["+y]])
vim.keymap.set('n', '<leader>Y', [["+Y]])

-- Scrolling on touchpads is remaped to the arrow keys by the terminal emulator.
-- Disable arrow keys will disable scrolling completely.
vim.keymap.set({ 'n', 'v' }, '<up>', '<nop>', { noremap = true })
vim.keymap.set({ 'n', 'v' }, '<down>', '<nop>', { noremap = true })
vim.keymap.set({ 'n', 'v' }, '<right>', '<nop>', { noremap = true })
vim.keymap.set({ 'n', 'v' }, '<left>', '<nop>', { noremap = true })

-- Diagnostic keymaps
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
-- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
-- vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Cycle my defined Colorsheme
vim.keymap.set('n', '<leader>cc', function()
  -- Defined colorschemes to loop through with keymap
  local colorschemesToLoop = { 'tokyonight', 'catppuccin', 'bluloco', 'sorbet', 'darkblue' }

  require('kkokou.utils.unofficial').cycleFavoriteColorScheme(colorschemesToLoop, vim.g.colors_name)
end, { silent = true, desc = '[leader] - [C]ycle [C]olorsheme' })
