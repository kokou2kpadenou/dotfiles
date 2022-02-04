-- Packer.vim
local fn = vim.fn
local packer_bootstrap

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
      require 'gitsignsconf'
    end
  }

  -- Git Commands Integration
  use 'tpope/vim-fugitive';

  -- Fuzzy Finder
  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
      {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
    },
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
    disable = false,
    requires = {'kyazdani42/nvim-web-devicons', opt = true},
    config = function()
      require 'lualinesetups/evil_lualine'
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
    disable = false,
    config = function()
      require 'materialconfig'
    end
  }


  -- AUTO COMPLETION
  ------------------
  -- Native LSP
  use {
    'neovim/nvim-lspconfig',
    requires = {
      'ray-x/lsp_signature.nvim',
    --   'jose-elias-alvarez/null-ls.nvim',
      'jose-elias-alvarez/nvim-lsp-ts-utils',
      -- Dev setup for init.lua and plugin development with full signature help, docs and completion for the nvim lua API.
      'folke/lua-dev.nvim',

      -- wrapper around the Lua code formatter, StyLua
      -- {
      --   "ckipp01/stylua-nvim",
      --   run = "cargo install stylua"
      -- },
    },
    config = function()
      require 'lsp'
    end
  }

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
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-buffer',
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-path',
      'ray-x/cmp-treesitter',
      'f3fora/cmp-spell',
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


  -- OTHERS
  ---------
  -- Visualizes undo history and makes it easier to browse and switch between different undo branches
  use 'mbbill/undotree'

  -- Comment test in and out
  use 'tpope/vim-commentary'
  -- use {
  --   'numToStr/Comment.nvim',
  --   config = function()
  --     require('comment').setup()
  --   end
  -- }

  -- Surroundings
  use 'tpope/vim-surround'

  -- EditorConfig for Vim
  use 'editorconfig/editorconfig-vim'

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
