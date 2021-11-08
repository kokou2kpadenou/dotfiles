" Move to the next match object
fun! NavNext()
  silent exec ":normal n"
endfun

" Move to the previous match object
fun! NavPrev()
  silent exec ":normal N"
endfun


" Navigation system
fun! CmdNavigation()

  
  let b:nav_old_line = exists('b:nav_old_line') ? b:nav_old_line : 1
  let b:nav_old_column = exists('b:nav_old_column') ? b:nav_old_column : 1

  let b:nav_current_line = line('.')
  let b:nav_current_column = virtcol('.')


  " Set the search register to object between []
  let @/= "\\[\\zs\\(.\\{-}\\)\\ze\\]"

  if b:nav_current_line == b:nav_old_line
    if b:nav_current_column >= b:nav_old_column
      call NavNext()
    endif

    if b:nav_current_column < b:nav_old_column
      call NavPrev()
    endif
  endif

  if b:nav_current_line > b:nav_old_line
    call NavNext()
  endif

  if b:nav_current_line < b:nav_old_line
    call NavPrev()
  endif

  let b:nav_old_line = line('.')
  let b:nav_old_column = virtcol('.')

endfun


fun! End()
  " Activate the ColorColumn highlight
  highlight ColorColumn ctermbg=0 guibg=Black
  " Activate the search highlight
  set hlsearch
  " Empty the search register
  let @/= ""
  " Enabled highlight matched parentheses
  silent exec ":DoMatchParen"
endfun


" Disable ColorColumn highlight
highlight ColorColumn NONE

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




fun! DisplayMessage()

  let g:banner_left_sep = "\uE0B4"
  let g:banner_right_sep = "\uE0B6"


  setlocal
    \ modifiable
    \ modified

  silent exec ":%d"

  " Our message goes here.
  " Commands display
  call append('0', "::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::")
  call append('1', ":::".g:banner_right_sep." [q] <quit>  [e] <new buffer> [i] or [o] <insert in new buffer> [H] <history> [s] <search> ".g:banner_left_sep.":::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::")
  call append('2', "::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::")
  call append('3', ":::".g:banner_right_sep." [F] <file explorer> -- Current directory: ".getcwd()." ".g:banner_left_sep."::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::")
  " Load content of banner.txt start from line 4
  silent exec "4:r ~/.config/nvim/banner.txt"

  " When we are done writing out message set the buffer to readonly.
  setlocal
    \ nomodifiable
    \ nomodified

  silent exec ":NoMatchParen"

endfun


call DisplayMessage()

" Just like with the default start page, when we switch to insert mode
" a new buffer should be opened which we can then later save.
nnoremap <buffer><silent> e :enew<CR>
nnoremap <buffer><silent> i :enew <bar> startinsert<CR>
nnoremap <buffer><silent> o :enew <bar> startinsert<CR>
nnoremap <buffer><silent> q :quit<CR>
nnoremap <buffer><silent> s :Telescope find_files<CR>
nnoremap <buffer><silent> H :Telescope oldfiles<CR>
nnoremap <buffer><silent> F :Telescope file_browser<CR>

nnoremap <buffer><silent> <tab> :normal l<CR>
nnoremap <buffer><silent> <S-tab> :normal h<CR>

nnoremap <buffer><silent> <C-e> <NOP>
nnoremap <buffer><silent> <C-y> <NOP>
nnoremap <buffer><silent> zt <NOP>

" Run the command under the cursor
nnoremap <buffer><silent> <CR> "zyi[:normal ".@z<CR>


autocmd CursorMoved <buffer> call CmdNavigation()

autocmd DirChanged <buffer> call DisplayMessage()

" Run Getin() function whenever buffer with typefile banner become active
autocmd BufEnter <buffer> call CmdNavigation()

" Run End() function when quitting banner for another files (buffers)
autocmd BufWipeout <buffer> call End()
