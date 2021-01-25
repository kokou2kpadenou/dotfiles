fun! Start()

  "Create a new unnamed buffer to display our splash screen inside of.
  enew

  " Set filetype to banner
  set ft=banner

  " Set some options for this buffer to make sure that does not act like a
  " normal winodw.
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

  " Set color
  highlight ColorColumn NONE


  " Our message goes here.
  call append('0', "::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::")
  call append('1', "::: [q] <quit>  [e] <new buffer> [i] or [o] <insert in new buffer> [h] <history> [s] <search> :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::")
  call append('2', "::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::")
  call append('3', "::: [<space>d] <file explorer> | Current directory: " . getcwd() . " ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::")
  silent exec "4:r ~/.config/nvim/banner.txt"
  silent exec ":1"

  " When we are done writing out message set the buffer to readonly.
  setlocal
    \ nomodifiable
    \ nomodified

  " Just like with the default start page, when we switch to insert mode
  " a new buffer should be opened which we can then later save.
  nnoremap <buffer><silent> e :enew<CR>
  nnoremap <buffer><silent> i :enew <bar> startinsert<CR>
  nnoremap <buffer><silent> o :enew <bar> startinsert<CR>
  nnoremap <buffer><silent> q :quit<CR>
  nnoremap <buffer><silent> s :Files<CR>
  nnoremap <buffer><silent> h :History<CR>


  " Disable some motions command
  " Left/Right/End
  noremap <buffer><silent> <Left> <Nop>
  noremap <buffer><silent> <Right> <Nop>
  noremap <buffer><silent> <End> <Nop>
  " h/l
  " noremap <buffer><silent> h <NOP>
  noremap <buffer><silent> l <NOP>

endfun

" http://learnvimscriptthehardway.stevelosh.com/chapters/12.html
" Autocommands are a way of setting handlers for certain events.
" `VimEnter` is the event we want to handle. http://vimdoc.sourceforge.net/htmldoc/autocmd.html#VimEnter
" The cleene star (`*`) is a pattern to indicate which filenames this Autocommand will apply too. In this case, star means all files.
" We will call the `Start` function to handle this event.

" http://vimdoc.sourceforge.net/htmldoc/eval.html#argc%28%29
" The number of files in the argument list of the current window.
" If there are 0 then that means this is a new session and we want to display
" our custom splash screen.
if argc() == 0
  autocmd VimEnter * call Start()
endif
