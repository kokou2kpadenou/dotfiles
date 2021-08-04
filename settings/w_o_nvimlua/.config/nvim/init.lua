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
g.loaded_python_provider = 0
g.loaded_python3_provider = 0

-- Packages manager Paq
require "paq" {
    "savq/paq-nvim";                  -- Let Paq manage itself

    "neovim/nvim-lspconfig";          -- Mind the semi-colons
    "hrsh7th/nvim-compe";

    --{"lervag/vimtex", opt=true};      -- Use braces when passing options
    'nvim-lua/plenary.nvim';
    'lewis6991/gitsigns.nvim';
    'sheerun/vim-polyglot';
    'hoob3rt/lualine.nvim';
    'kyazdani42/nvim-web-devicons';
    "tpope/vim-surround";
    'tjdevries/colorbuddy.vim';
}

-- Options
vim.o.completeopt = "menuone,noselect"
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

opt.list = false
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

-- gruvbudy - colorscheme
require('colorbuddy').colorscheme('gruvbuddy')
-- gitsigns
require('gitsigns').setup()

-- compe
require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  resolve_timeout = 800;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = {
    border = { '', '' ,'', ' ', '', '', '', ' ' }, -- the border option is the same as `|help nvim_open_win|`
    winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
    max_width = 120,
    min_width = 60,
    max_height = math.floor(vim.o.lines * 0.3),
    min_height = 1,
  };

  source = {
    path = true;
    buffer = true;
    calc = true;
    nvim_lsp = true;
    nvim_lua = true;
    vsnip = true;
    ultisnips = true;
    luasnip = true;
  };
}
