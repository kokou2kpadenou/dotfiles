" Plugins
""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin('~/.vim/plugged')

Plug 'morhetz/gruvbox'
Plug 'mbbill/undotree'
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

Plug 'terryma/vim-multiple-cursors'
Plug 'alvan/vim-closetag'
Plug 'tpope/vim-surround'
Plug 'prettier/vim-prettier', { 'do': 'npm install', 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'yaml', 'html'] }
Plug 'mattn/emmet-vim', { 'for': ['html', 'css', 'javascript'] }
"Plug 'sheerun/vim-polyglot'
Plug 'leafgarland/typescript-vim'
Plug 'ycm-core/YouCompleteMe'
Plug 'SirVer/ultisnips'
Plug 'mlaursen/vim-react-snippets'

call plug#end()


" Setup
""""""""""""""""""""""""""""""""""""""""""""""""""

set nocompatible
syntax on                                                                       
filetype plugin indent on

                                                                               
set noerrorbells                                                                
set tabstop=4 softtabstop=4                                                     
set shiftwidth=4                                                                
set expandtab                                                                   
set smartindent                                                                 
set nu rnu                                                                          
set nowrap                                                                      
set smartcase                                                                   
set noswapfile                                                                  
set nobackup                                                                    
set undodir=~/.vim/undodir                                                      
set undofile                                                                    
set incsearch
set hlsearch                                                                    
set nolazyredraw 
set magic
                                                                                 
set colorcolumn=80                                                              
highlight ColorColumn ctermbg=0 guibg=lightgrey 

" FILES SEARCHING
set path+=**
set wildmenu
set wildignore+=**/node_modules/** 
set hidden

" Color
colorscheme gruvbox
set background=dark

if (has("termguicolors"))
  set termguicolors
endif


" Section folding
set foldenable
set foldlevelstart=10
set foldnestmax=10
set foldmethod=syntax
nnoremap <space> za

" commands
command! MakeTags !ctags -R .

" netrw browsing
let g:netrw_banner=0        " disable annoying banner
let g:netrw_liststyle=3     " tree view
let g:netrw_bufsettings="noma nomod nonu nobl nowrap ro rnu"
let g:netrw_list_hide= 'node_modules,.git'

" Prettier
let g:prettier#config#single_quote = "false"
let g:prettier#config#trailing_comma = "none"
let g:prettier#autoformat = 0
autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue,*.yaml,*.html Prettier

" UltiSnips
let g:UltiSnipsExpandTrigger="<c-e>"
let g:UltiSnipsJumpForwardTrigger="<c-f>"
let g:UltiSnipsJumpBackwardTrigger="<c-b>"

" Enable AutoCompletion.
set omnifunc=syntaxcomplete#complete

" Mapping
nnoremap <leader><space> :nohlsearch<CR>


" JavaScript Simple AutoClose ', ", (, {, [
fun! AutoCloseJavaScript()
    inoremap " ""<left>
    inoremap ' ''<left>
    inoremap ( ()<left>
    inoremap [ []<left>
    inoremap { {}<left>
    inoremap {<CR> {<CR>}<ESC>O
    inoremap {;<CR> {<CR>};<ESC>O
endfun

autocmd FileType javascript :call AutoCloseJavaScript()

" Emmet
let g:user_emmet_leader_key = ','
let g:user_emmet_settings = {
\  'javascript' : {
\      'extends' : 'jsx',
\  },
\}
