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
opt.completeopt = 'menu,menuone,noselect'
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
--[[ opt.listchars = { eol = '¬', tab = '>.', trail = '~', extends = '>', space = '␣', precedes = '<' } ]]
opt.listchars = { eol = '¬', tab = '>.', trail = '~', extends = '>', space = '⋅', precedes = '<' }

opt.clipboard = 'unnamedplus'

opt.termguicolors = true

opt.foldenable = true
opt.foldlevelstart = 90
opt.foldnestmax = 10
opt.foldmethod = 'expr'
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldcolumn = '1'

opt.path = opt.path + '**'
opt.wildmenu = true
opt.wildignore = opt.wildignore + { '*/node_modules/*', '*/.next/*', '*/out/*', '*/dist/*', '*/tmp/*' }
opt.hidden = true

-- netrw
g.netrw_banner = 0 -- disable annoying banner
g.netrw_liststyle = 3 -- Tree style view
g.netrw_bufsettings = 'noma nomod nonu nobl nowrap ro rnu'
-- g.netrw_browse_split = 4 -- Open in previous window
-- g.netrw_altv = 1 -- Open with right splitting
g.netrw_list_hide = (vim.fn['netrw_gitignore#Hide']())
  .. [[,\(^\|\s\s\)\zs\.\S\+]]
  .. [[,node_modules]]
  .. [[,^dist$]]
  .. [[,^tags$]]
  .. [[,^out$]]
  .. [[,^build$]] -- use .gitignore
g.netrw_winsize = 35

-- Undo history
opt.undodir = fn.stdpath 'config' .. '/undodir'
opt.undofile = true

-- Disable mouse and scrolling
opt.mouse = ''
-- FIXME: disable mousescroll not working for now.
-- opt.mousescroll = 'ver:0,hor:0'
