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
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)
