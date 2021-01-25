" Plugins
""""""""""""""""""""""""""""""""""""""""""""""""""
" Plug is already installed
let plug_install  = 0

let autoload_plug_path = stdpath('data') . '/site/autoload/plug.vim'

if !filereadable(autoload_plug_path)
  silent execute '!curl -fLo ' . autoload_plug_path . '  --create-dirs 
      \ "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"'
  " Plug is just installed
  let plug_install = 1
endif

unlet autoload_plug_path

call plug#begin('~/.config/nvim/plugged')

Plug 'morhetz/gruvbox'
Plug 'mbbill/undotree'
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'dyng/ctrlsf.vim'

Plug 'tpope/vim-surround'
Plug 'tyru/caw.vim'
Plug 'mattn/emmet-vim', { 'for': ['html', 'css', 'javascript'] }
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets' | Plug 'mlaursen/vim-react-snippets'

Plug 'sheerun/vim-polyglot'

Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'vimwiki/vimwiki'

call plug#end()

" Install the plugins if Plug is just installed
if plug_install
  PlugInstall --sync
endif

unlet plug_install
