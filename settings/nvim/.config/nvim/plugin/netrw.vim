let g:netrw_banner=0        " disable annoying banner
let g:netrw_liststyle=3     " tree view
let g:netrw_bufsettings="noma nomod nonu nobl nowrap ro rnu"
let g:netrw_list_hide= 'node_modules,.git,tags,.next,out,build,dist'
" Per default, netrw leaves unmodified buffers open. this autocommand
" deletes netrw's buffer once it's hidden (using ':q;, for example)
" or use :qa!
autocmd FileType netrw setl bufhidden=delete
autocmd FileType netrw setl nolist



