-- Helpers
local fn = vim.fn -- to call Vim functions e.g. fn.bufnr()
local g = vim.g -- a table to access global variables
local o = vim.o -- to set options

g.loaded_ruby_provider = 0
g.loaded_perl_provider = 0
g.loaded_python_provider = 0
g.loaded_python3_provider = 0
g.loaded_node_provider = 0

-- Options
o.completeopt = 'menu,menuone,noselect'
o.cursorline = true
o.errorbells = false
o.tabstop = 2
o.softtabstop = 2
o.shiftwidth = 2
o.expandtab = true
o.smartindent = true
o.number = true
o.relativenumber = true
o.wrap = false
o.smartcase = true
o.swapfile = false
o.backup = false
o.writebackup = false
o.incsearch = true
o.hlsearch = true
o.lazyredraw = false
o.magic = true
-- o.cmdheight = 1
o.updatetime = 300
vim.opt.shortmess = vim.opt.shortmess + 'c'
o.signcolumn = 'yes'
o.showcmd = true

o.list = true
vim.opt.listchars = { eol = '¬', tab = '>.', trail = '~', extends = '>', space = '⋅', precedes = '<' }

o.clipboard = 'unnamedplus'

o.termguicolors = true

o.foldenable = true
o.foldlevelstart = 90
o.foldnestmax = 5
o.foldmethod = 'expr'
o.foldexpr = "nvim_treesitter#foldexpr()"
o.foldcolumn = '1'

vim.opt.path = vim.opt.path + '**'
o.wildmenu = true
vim.opt.wildignore = vim.opt.wildignore + { '*/node_modules/*', '*/.next/*', '*/out/*', '*/dist/*', '*/tmp/*' }
o.hidden = true

-- netrw
g.netrw_banner = 0 -- disable annoying banner
g.netrw_liststyle = 3 -- Tree style view
g.netrw_bufsettings = 'noma nomod nonu nobl nowrap ro rnu'
g.netrw_list_hide = (vim.fn['netrw_gitignore#Hide']())
  .. [[,\(^\|\s\s\)\zs\.\S\+]]
  .. [[,node_modules]]
  .. [[,^dist$]]
  .. [[,^tags$]]
  .. [[,^out$]]
  .. [[,^build$]] -- use .gitignore
g.netrw_winsize = 35

-- Undo history
o.undodir = fn.stdpath 'config' .. '/undodir'
o.undofile = true

-- Disable mouse and scrolling
o.mouse = ''
-- FIXME: disable mousescroll not working for now.
o.mousescroll = 'ver:0,hor:0'
