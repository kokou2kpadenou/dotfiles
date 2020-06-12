" Plugins
""""""""""""""""""""""""""""""""""""""""""""""""""
function! BuildYCM(info)
  " info is a dictionary with 3 fields
  " - name:   name of the plugin
  " - status: 'installed', 'updated', or 'unchanged'
  " - force:  set on PlugInstall! or PlugUpdate!
  if a:info.status == 'installed' || a:info.force
    !./install.py
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
"set showcmd
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
map <F2> :MakeTags <CR>
nnoremap <F5> :buffers<CR>:buffer<Space>
map <F7> gg=G<C-o><C-o>
map <F9> :bel term ++rows=10 <CR>
vnoremap <C-c> "*y :let @+=@*<CR>
map <C-p> "+p


" Simple AutoClose ', ", (, {, [
function! SimpleAutoClose()
    inoremap " ""<left>
    inoremap ' ''<left>
    inoremap ( ()<left>
    inoremap [ []<left>
    inoremap { {}<left>
    inoremap {<CR> {<CR>}<ESC>O
    inoremap {;<CR> {<CR>};<ESC>O
endfunction

autocmd FileType javascript,typescript,css :call SimpleAutoClose()

" Emmet
let g:user_emmet_leader_key = ','
let g:user_emmet_settings = {
\  'javascript' : {
\      'extends' : 'jsx',
\  },
\}
