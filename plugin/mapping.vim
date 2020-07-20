" Mapping
nnoremap <leader><space> :nohlsearch<CR>
map <leader>, gg=G<C-o><C-o>|                       "Reformat the whole page
map <leader>/ :find<space>|                         "Find file by name
map <leader>\ :vim // **/* <left><left><left><left><left><left><left>|                          "Find file by contain match
nnoremap <leader>] :YcmCompleter GoTo<CR>|          "YCM's GoTo

map <F2> :set rnu!<cr>|                             "toggle relative number
map <F3> :set nu!<cr>|                              "toggle number
nnoremap <F4> :bdelete <CR>|                        "Close the current buffer
nnoremap <F5> :ls<CR>:buffer<Space>|                "List of buffers
nnoremap <F6> :e .<CR>|                             "Open netrw
nnoremap <F7> :UndotreeToggle<CR>|                  "Toggle undotree
map <F8> :MakeTags <CR>|                            "Run ctags command
map <F9> :bel term ++rows=10 <CR>|                  "Open vim terminal with 10 rows in bottom

noremap <F10> :set list!<CR>|                       "toggle list - normal mode
inoremap <F10> <C-o>:set list!<CR>|                 "toggle list - insert mode
cnoremap <F10> <C-c>:set list!<CR>|                 "toggle list - command mode

vnoremap <C-c> "*y :let @+=@*<CR>|                  "Copy to system clipboard
map <C-p> "+p|                                      "Paste from system clipboard
