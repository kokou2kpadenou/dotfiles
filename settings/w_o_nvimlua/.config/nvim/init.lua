-- Helpers
local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn    -- to call Vim functions e.g. fn.bufnr()
local g = vim.g      -- a table to access global variables
local opt = vim.opt  -- to set options

local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

g.loaded_ruby_provider = 0
g.loaded_perl_provider = 0
-- g.perl_host_prog = '/usr/bin/perl'
g.loaded_python_provider = 0
g.loaded_python3_provider = 0



-- Options
vim.o.completeopt = "menu,menuone,noselect"
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
opt.signcolumn = "yes"
opt.showcmd = true

opt.list = true
opt.listchars = { eol = '¬', tab = '>.', trail = '~', extends = '>', space = '␣', precedes = '<'}

opt.clipboard = "unnamedplus"

opt.termguicolors = true
opt.foldenable = true
opt.foldlevelstart = 90
opt.foldnestmax = 10
opt.foldmethod = 'syntax'
opt.foldcolumn = '1'

opt.path = opt.path + '**'
opt.wildmenu = true
opt.wildignore = opt.wildignore + {'**/node_modules/**', '**/.next/**', '**/out/**', '**/dist/**', '**/tmp/**'}
opt.hidden = true

g.netrw_banner = 0        -- disable annoying banner
g.netrw_liststyle = 3     -- tree
g.netrw_bufsettings = 'noma nomod nonu nobl nowrap ro rnu'
g.netrw_list_hide = {'node_modules'}

opt.undodir = fn.stdpath('config') .. '/undodir'
opt.undofile = true


-- Packer.vim
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

return require('packer').startup(function(use)
  -- My plugins here
  -- use 'foo1/bar1.nvim'
  -- use 'foo2/bar2.nvim'

  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- FILES MANAGEMENT
  -- Git Decorations Integration
  use {
    'lewis6991/gitsigns.nvim',
    requires = {
      'nvim-lua/plenary.nvim'
    },
    config = function()
      require('gitsigns').setup()
    end
  }

  -- Git Commands Integration
  use 'tpope/vim-fugitive';

  -- Fuzzy Finder
  use {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  -- APPARENCE
  -- TreeSitter
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }
  -- Status Line
  use {
    'nvim-lualine/lualine.nvim',
    requires = {'kyazdani42/nvim-web-devicons', opt = true}
  }
  -- Color highlighter for Neovim
  use {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require'colorizer'.setup()
    end
  }

  -- colorscheme
  use {
    'Th3Whit3Wolf/onebuddy',
    requires = {
      'tjdevries/colorbuddy.vim'
    },
    config = function()
      require('colorbuddy').colorscheme('onebuddy')
    end
  }


  -- AUTO COMPLETION
  -- Native LSP
  use 'neovim/nvim-lspconfig'

  use {
    'hrsh7th/nvim-cmp',
    requires = {
      {'L3MON4D3/LuaSnip', requires = {'rafamadriz/friendly-snippets'} }, -- Snippets
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-path',
      {'kristijanhusak/vim-dadbod-completion', opt = true},
      'onsails/lspkind-nvim' -- This tiny plugin adds vscode-like pictograms to neovim built-in lsp
    },
  }
  -- Emmet
  use 'mattn/emmet-vim'
  -- Autopairs for Neovim
  use 'windwp/nvim-autopairs'

  -- DATABASES
  use {
    'kristijanhusak/vim-dadbod-ui',
    requires = {
      'tpope/vim-dadbod'
    },
  }


  -- OTHERS
  -- Visualizes undo history and makes it easier to browse and switch between different undo branches
  use 'mbbill/undotree'
  -- Comment test in and out
  use 'tpope/vim-commentary'
  -- Surroundings
  use 'tpope/vim-surround'

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
