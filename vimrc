" Plugins
""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin('~/.vim/plugged')

Plug 'morhetz/gruvbox'
Plug 'mbbill/undotree'
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

Plug 'mattn/emmet-vim'
Plug 'leafgarland/typescript-vim'
Plug 'ycm-core/YouCompleteMe'
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

" FILES EARCHING
set path+=**
set wildmenu
set wildignore+=**/node_modules/** 
set hidden

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

" Prettier
let g:prettier#config#single_quote = "false"
let g:prettier#config#trailing_comma = "none"
let g:prettier#autoformat = 0
autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue,*.yaml,*.html Prettier

" Enable AutoCompletion.
set omnifunc=syntaxcomplete#complete





