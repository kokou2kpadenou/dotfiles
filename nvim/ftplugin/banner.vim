" Set some options for this buffer to make sure that does not act like a
" normal window.
setlocal
  \ bufhidden=wipe
  \ buftype=nofile
  \ nobuflisted
  \ nocursorcolumn
  \ nocursorline
  \ nolist
  \ nonumber
  \ noswapfile
  \ norelativenumber
  \ foldcolumn=0
  \ signcolumn=no
  \ nohlsearch

" Just like with the default start page, when we switch to insert mode
" a new buffer should be opened which we can then later save.
nnoremap <buffer><silent> e :enew<CR>
nnoremap <buffer><silent> i :enew <bar> startinsert<CR>
nnoremap <buffer><silent> o :enew <bar> startinsert<CR>
nnoremap <buffer><silent> q :quit<CR>
nnoremap <buffer><silent> s :Files<CR>
nnoremap <buffer><silent> H :History<CR>
nnoremap <buffer><silent> <space>d :CocCommand explorer<CR>

" Disable some motions command
" Left/Right/End
noremap <buffer><silent> <Left> N:echo<CR>
noremap <buffer><silent> <Up> N:echo<CR>
noremap <buffer><silent> <Right> n:echo<CR>
noremap <buffer><silent> <Down> n:echo<CR>
noremap <buffer><silent> <End> <Nop>
" h/l
noremap <buffer><silent> h N:echo<CR>
noremap <buffer><silent> k N:echo<CR>
noremap <buffer><silent> l n:echo<CR>
noremap <buffer><silent> j n:echo<CR>

" Run the command under the cursor
nnoremap <buffer><silent> <CR> "zyi[:normal ".@z.""<CR>

" disable mouse interactions "
" setlocal mouse=nicr
map <buffer> <ScrollWheelUp> N:echo<CR>
map <buffer> <S-ScrollWheelUp> N:echo<CR>
map <buffer> <C-ScrollWheelUp> N:echo<CR>
map <buffer> <ScrollWheelDown> n:echo<CR>
map <buffer> <S-ScrollWheelDown> n:echo<CR>
map <buffer> <C-ScrollWheelDown> n:echo<CR>
map <buffer> <ScrollWheelLeft> N:echo<CR>
map <buffer> <S-ScrollWheelLeft> N:echo<CR>
map <buffer> <C-ScrollWheelLeft> N:echo<CR>
map <buffer> <ScrollWheelRight> n:echo<CR>
map <buffer> <S-ScrollWheelRight> n:echo<CR>
map <buffer> <C-ScrollWheelRight> n:echo<CR>

fun! Getin()

  " Move to 1st line
  silent exec ":1"
  " Set the search register to object between []
  let @/= "\\[\\zs\\(.\\{-}\\)\\ze\\]"
  " Move to the next match object
  silent exec ":normal n"

endfun

" Run Getin() function whenever buffer with typefile banner become active
autocmd BufEnter *.banner call Getin()
