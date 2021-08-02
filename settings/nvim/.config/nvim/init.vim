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

" Set space, end of line, tabulation, trail, precedes and extends
set list
set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣

" FILES SEARCHING
set path+=$PWD/**
set wildmenu
set wildignore+=**/node_modules/**,**/.next/**,**/out/**,**/.git/**,**/tags,**/dist/**,**/tmp/**
set hidden

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

if exists('+termguicolors')
  let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

fun! SetColorSheme()
  " Set colorscheme to gruvbox
  colorscheme gruvbox
  " Set ColorColumn from 80 characters
  match ColorColumn /\%80v.\+/
  " Transparent Backgfround
  hi Normal guibg=NONE ctermbg=NONE
endfun

" Set colorscheme after enter vim
autocmd vimenter * ++nested call SetColorSheme()

" Highlighting for large files
autocmd BufEnter *.{js,jsx,ts,tsx} :syntax sync fromstart
autocmd BufLeave *.{js,jsx,ts,tsx} :syntax sync clear
