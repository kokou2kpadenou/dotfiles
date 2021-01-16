" Mapping
nnoremap <leader><space> :nohlsearch<CR>

"Reformat the whole page
map <leader>, gg=G<C-o><C-o>

"Find file by name
map <leader>/ :find<space>

"Find file by contain match
map <leader>\ :vim // **/* <left><left><left><left><left><left><left>

"toggle relative number
map <F2> :set rnu!<cr>

"toggle number
map <F3> :set nu!<cr>

"Close the current buffer
nnoremap <F4> :bdelete! <CR>
"List of buffers
nnoremap <F5> :ls<CR>:buffer<Space>
"Open netrw
nnoremap <F6> :e .<CR>
"Toggle undotree -- See plugin/undotree.vim
" nnoremap <F7> :UndotreeToggle<CR>
" map <F9> :bel term ++rows=10 <CR>|                  "Open vim terminal with 10 rows in bottom

"toggle list
" - normal mode
noremap <F10> :set list!<CR>
" - insert mode>
inoremap <F10> <C-o>:set list!<CR>
" - command mode
cnoremap <F10> <C-c>:set list!<CR>

"Copy to system clipboard
" vnoremap <C-c> "*y :let @+=@*<CR>
"Paste from system clipboard
" map <C-p> "+p
