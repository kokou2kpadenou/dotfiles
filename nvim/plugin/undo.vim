silent !mkdir ~/.config/nvim/undodir > /dev/null 2>&1

set undodir=~/.config/nvim/undodir
set undofile

"Toggle undotree mapping
nnoremap <F7> :UndotreeToggle<CR>

