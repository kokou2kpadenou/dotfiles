fun! Start()

  " Create a new unnamed buffer to display our splash screen inside of.
  enew

  " Set filetype to banner
  setlocal ft=banner

endfun


if argc() == 0
  autocmd VimEnter <buffer> call Start()
endif
