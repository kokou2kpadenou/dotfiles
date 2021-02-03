fun! Start()

  " Create a new unnamed buffer to display our splash screen inside of.
  enew

  " Set filetype to banner
  set ft=banner

  " Set the buffer file name
  silent exec ":file screen.banner"

  " Disable ColorColumn highlight
  highlight ColorColumn NONE


  " Our message goes here.
  " Commands display
  call append('0', "::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::")
  call append('1', "::: [q] <quit>  [e] <new buffer> [i] or [o] <insert in new buffer> [H] <history> [s] <search> :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::")
  call append('2', "::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::")
  call append('3', "::: [<space>d] <file explorer> | Current directory: " . getcwd() . " ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::")
  " Load content of banner.txt start from line 4
  silent exec "4:r ~/.config/nvim/banner.txt"
  " Move to 1st line
  silent exec ":1"

  " When we are done writing out message set the buffer to readonly.
  setlocal
    \ nomodifiable
    \ nomodified


  " Set the search register to object between []
  let @/= "\\[\\zs\\(.\\{-}\\)\\ze\\]"
  " Move to the next match object
  silent exec ":normal n"


endfun


fun! End()
  " Activate the ColorColumn highlight
  highlight ColorColumn ctermbg=0 guibg=Black
  " Activate the search highlight
  set hlsearch
  " Empty the search register
  let @/= ""
endfun

" Run End() function when quitting banner for another files (buffers)
autocmd BufWipeout *.banner ++once call End()

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
