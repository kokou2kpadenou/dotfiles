-- [[ Global variables ]]
-- Set the leader key
vim.g.mapleader = '\\'
vim.g.maplocalleader = '\\'

-- Desable providers
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_node_provider = 0

-- netrw
-- vim.g.netrw_banner = 0 -- disable annoying banner
-- vim.g.netrw_liststyle = 3 -- Tree style view
-- vim.g.netrw_bufsettings = 'noma nomod nonu nobl nowrap ro rnu'
-- vim.g.netrw_list_hide = (vim.fn['netrw_gitignore#Hide']())
--   .. [[,\(^\|\s\s\)\zs\.\S\+]]
--   .. [[,node_modules]]
--   .. [[,^dist$]]
--   .. [[,^tags$]]
--   .. [[,^out$]]
--   .. [[,^build$]] -- use .gitignore
-- vim.g.netrw_winsize = 35

-- Skip backwards compatibility routines and speed up loading
vim.g.skip_ts_context_commentstring_module = true

-- [[ Options ]]
vim.opt.completeopt = 'menu,menuone,noselect'
vim.opt.cursorline = true
vim.opt.errorbells = false
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.smartcase = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.lazyredraw = false
vim.opt.magic = true
vim.opt.updatetime = 300
vim.opt.shortmess = vim.opt.shortmess + 'c'
vim.opt.signcolumn = 'yes'
vim.opt.showcmd = true
vim.opt.scrolloff = 4

-- Sets how neovim will display certain whitespace characters in the editor.
vim.opt.list = true
vim.opt.listchars = { eol = '¬', tab = '>.', trail = '~', extends = '>', space = '⋅', precedes = '<' }

vim.opt.clipboard = 'unnamedplus'

vim.opt.termguicolors = true

vim.opt.foldenable = true
vim.opt.foldlevelstart = 90
vim.opt.foldnestmax = 5
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.foldcolumn = '1'

vim.opt.path = vim.opt.path + '**'
vim.opt.wildmenu = true
vim.opt.wildignore = vim.opt.wildignore + { '*/node_modules/*', '*/.next/*', '*/out/*', '*/dist/*', '*/tmp/*' }
vim.opt.hidden = true

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Save undo history
vim.opt.undofile = true

-- Disable mouse and scrolling
vim.opt.mouse = ''
