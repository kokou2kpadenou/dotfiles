-- Helpers
local fn = vim.fn -- to call Vim functions e.g. fn.bufnr()
local g = vim.g -- a table to access global variables
local opt = vim.opt -- to set options

g.loaded_ruby_provider = 0
g.loaded_perl_provider = 0
g.loaded_python_provider = 0
g.loaded_python3_provider = 0
g.loaded_node_provider = 0

-- Options
vim.o.completeopt = 'menu,menuone,noselect'
opt.cursorline = true
opt.errorbells = false
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true
opt.number = true
opt.relativenumber = true
opt.wrap = false
opt.smartcase = true
opt.swapfile = false
opt.backup = false
opt.writebackup = false
opt.incsearch = true
opt.hlsearch = true
opt.lazyredraw = false
opt.magic = true
opt.cmdheight = 2
opt.updatetime = 300
opt.shortmess = opt.shortmess + 'c'
opt.signcolumn = 'yes'
opt.showcmd = true

opt.list = true
opt.listchars = { eol = '¬', tab = '>.', trail = '~', extends = '>', space = '␣', precedes = '<' }

opt.clipboard = 'unnamedplus'

opt.termguicolors = true

opt.foldenable = true
opt.foldlevelstart = 90
opt.foldnestmax = 10
opt.foldmethod = 'syntax'
opt.foldcolumn = '1'

opt.path = opt.path + '**'
opt.wildmenu = true
opt.wildignore = opt.wildignore + { '*/node_modules/*', '*/.next/*', '*/out/*', '*/dist/*', '*/tmp/*' }
opt.hidden = true

g.netrw_banner = 0 -- disable annoying banner
g.netrw_liststyle = 3 -- tree
g.netrw_bufsettings = 'noma nomod nonu nobl nowrap ro rnu'
g.netrw_list_hide = 'node_modules,.git,tags,.next,out,build,dist'

opt.undodir = fn.stdpath 'config' .. '/undodir'
opt.undofile = true
