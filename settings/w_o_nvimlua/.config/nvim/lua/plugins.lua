-- Packer.vim
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

return require('packer').startup(function(use)

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
    requires = { {'nvim-lua/plenary.nvim'} },
    config = function()
      require 'telescopeconfig'
    end
  }


  -- APPARENCE
  -- TreeSitter
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    requires = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      'nvim-treesitter/nvim-treesitter-refactor'
    },
    config = function()
      require 'treesitterconfig'
    end
  }
  -- Status Line
  use {
    'nvim-lualine/lualine.nvim',
    requires = {'kyazdani42/nvim-web-devicons', opt = true},
    config = function()
      require 'lualineconfig'
    end
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
    'marko-cerovac/material.nvim',
    config = function()
      require 'materialconfig'
    end
  }


  -- AUTO COMPLETION
  ------------------
  -- Native LSP
  use 'neovim/nvim-lspconfig'
  -- Completion Engine Plugin
  use {
    'hrsh7th/nvim-cmp',
    requires = {
      -- Snippets
      {
        'L3MON4D3/LuaSnip',
        requires = {'rafamadriz/friendly-snippets'},
        config = function()
          require 'snippets'
        end
      },
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-path',
      {'kristijanhusak/vim-dadbod-completion', opt = true},
      'onsails/lspkind-nvim', -- This tiny plugin adds vscode-like pictograms to neovim built-in lsp
      'f3fora/cmp-spell', -- TODO: setup spell
      'hrsh7th/cmp-cmdline'
    },
    config = function()
      require 'completion'
    end
  }
  -- Emmet
  use {
    'mattn/emmet-vim',
    config = function()
      require 'emmetconfig'
    end
  }
  -- Autopairs for Neovim
  use {
    'windwp/nvim-autopairs',
    config = function()
      require 'autopairs'
    end
  }


  -- DATABASES
  use {
    'kristijanhusak/vim-dadbod-ui',
    requires = {
      'tpope/vim-dadbod'
    },
  }


  -- OTHERS
  ---------
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
