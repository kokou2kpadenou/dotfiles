" Plugins
""""""""""""""""""""""""""""""""""""""""""""""""""
function! BuildYCM(info)
    " info is a dictionary with 3 fields
    " - name:   name of the plugin
    " - status: 'installed', 'updated', or 'unchanged'
    " - force:  set on PlugInstall! or PlugUpdate!
    if a:info.status == 'installed' || a:info.force
        !./install.py --ts-completer
    endif
endfunction

call plug#begin('~/.vim/plugged')

Plug 'nanotech/jellybeans.vim'
Plug 'joshdick/onedark.vim'
Plug 'morhetz/gruvbox'
Plug 'mbbill/undotree'
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

Plug 'terryma/vim-multiple-cursors'
Plug 'tyru/caw.vim'
Plug 'alvan/vim-closetag'
Plug 'tpope/vim-surround'
Plug 'prettier/vim-prettier', { 'do': 'npm install', 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'yaml', 'html'] }
Plug 'mattn/emmet-vim', { 'for': ['html', 'css', 'javascript'] }
"Plug 'sheerun/vim-polyglot'
Plug 'pangloss/vim-javascript'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'leafgarland/typescript-vim'
Plug 'ycm-core/YouCompleteMe', { 'do': function('BuildYCM') }
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets' | Plug 'mlaursen/vim-react-snippets'

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

" set colorcolumn=80
highlight ColorColumn ctermbg=0 guibg=lightgrey 
match ColorColumn /\%80v.\+/

set list
set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣

" FILES SEARCHING
set path+=$PWD/**
set wildmenu
set wildignore+=**/node_modules/**,.next/**,out/**,.git/**,tags
set hidden

" Color
colorscheme gruvbox
set background=dark
if (has("termguicolors"))
    set termguicolors
endif


" Section folding
set foldenable
set foldlevelstart=99
set foldnestmax=10
set foldmethod=syntax
set foldcolumn=1
let javaScript_fold=1
let sh_fold_enabled=1

" commands
command! MakeTags !ctags -R .

" netrw browsing
let g:netrw_banner=0        " disable annoying banner
let g:netrw_liststyle=3     " tree view
let g:netrw_bufsettings="noma nomod nonu nobl nowrap ro rnu"
let g:netrw_list_hide= 'node_modules,.git,tags,.next,out,build,dist'
" Per default, netrw leaves unmodified buffers open. this autocommand
" deletes netrw's buffer once it's hidden (using ':q;, for example)
autocmd FileType netrw setl bufhidden=delete " or use :qa!
autocmd FileType netrw setl nolist

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

" Emmet
let g:user_emmet_leader_key = ','
let g:user_emmet_settings = {
            \  'javascript' : {
            \      'extends' : 'jsx',
            \  },
            \}

" YouCompleteMe
let g:ycm_collect_identifiers_from_tags_files = 1

