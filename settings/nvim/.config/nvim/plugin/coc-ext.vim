let g:coc_global_extensions = [
  \ 'coc-tsserver',
  \ 'coc-json',
  \ 'coc-emmet',
  \ 'coc-highlight',
  \ 'coc-lists',
  \ 'coc-pairs',
  \ 'coc-snippets',
  \ 'coc-explorer',
  \ 'coc-tailwindcss',
  \ ]

if isdirectory('./node_modules') && isdirectory('./node_modules/prettier')
    let g:coc_global_extensions += ['coc-prettier']
  endif

if isdirectory('./node_modules') && isdirectory('./node_modules/eslint')
      let g:coc_global_extensions += ['coc-eslint']
    endif
