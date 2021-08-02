""""""""""""""""""""""
" PLUGINS MANAGEMENT "
""""""""""""""""""""""


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


" PLUG CONFIGURATION

call plug#begin('~/.config/nvim/plugged')


" APPEARANCE
" ----------

" Themes
  Plug 'morhetz/gruvbox'

" Status Line
  Plug 'vim-airline/vim-airline'


" FILE MANAGEMENT
" ---------------

" Git Integration
  Plug 'tpope/vim-fugitive'
  Plug 'airblade/vim-gitgutter'

" Fuzzy Finder
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'

" An ack/ag/pt/rg powered code search and view tool
  Plug 'dyng/ctrlsf.vim'


" LANGUAGES
" ---------

" language packs
  Plug 'sheerun/vim-polyglot'


" AUTOCOMPLETION
" --------------

" Intellisense
  Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Snippets
  Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets' | Plug 'mlaursen/vim-react-snippets'

" Emmet
  Plug 'mattn/emmet-vim', { 'for': ['html', 'css', 'javascript'] }

" surroundings: parentheses, brackets, quotes, XML tags, and more
  Plug 'tpope/vim-surround'


" OTHERS
" ------

" Comments
  Plug 'tyru/caw.vim'

" Undo Tree: The plug-in visualizes undo history and makes it easier to browse and switch between different undo branches.
  Plug 'mbbill/undotree'

" Note taking
  Plug 'vimwiki/vimwiki'

" Display Calendar
  Plug 'mattn/calendar-vim'


call plug#end()



" Install the plugins if Plug is just installed
if plug_install
  PlugInstall --sync
endif

unlet plug_install
