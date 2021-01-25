" Plugins Management
""""""""""""""""""""""""""""""""""""""""""""""""""
source ~/.config/nvim/sources/plug.vim

" Basic Setting
""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible
syntax on
filetype plugin indent on

set noerrorbells
set tabstop=2 softtabstop=2
set shiftwidth=2
set expandtab
set smartindent
set nu rnu
set nowrap
set smartcase
set noswapfile
set nobackup
set incsearch
set hlsearch
set nolazyredraw
set magic

" Set colorcolumn to 80
fun! Matchs()
  highlight ColorColumn ctermbg=0 guibg=Black
  match ColorColumn /\%80v.\+/
endfun

autocmd BufNewFile,BufRead * call Matchs()

" Set space, end of line, tabulation, trail, precedes and extends
set list
set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣

" FILES SEARCHING
set path+=$PWD/**
set wildmenu
set wildignore+=**/node_modules/**,**/.next/**,**/out/**,**/.git/**,**/tags,**/dist/**,**/tmp/**
set hidden

" Color
colorscheme gruvbox
set background=dark
set termguicolors

" Transparent Backgfround
autocmd vimenter * hi Normal guibg=NONE ctermbg=NONE

" Clipboard - Copy/Paste from/to System
set clipboard+=unnamedplus

" Section folding - Javascript
set foldenable
set foldlevelstart=99
set foldnestmax=10
set foldmethod=syntax
set foldcolumn=1
let javaScript_fold=1
let sh_fold_enabled=1

" Enable AutoCompletion.
set omnifunc=syntaxcomplete#complete

" Highlighting for large files
autocmd BufEnter *.{js,jsx,ts,tsx} :syntax sync fromstart
autocmd BufLeave *.{js,jsx,ts,tsx} :syntax sync clear

" Lang
" set spell
" set spelllang=en-us,fr_ch
