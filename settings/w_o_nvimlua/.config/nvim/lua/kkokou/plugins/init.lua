-- Packer.vim
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system { 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path }
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup {
  function(use)
    -- PERFORMANCE, PACKAGES AND PLUGINS MANAGEMENT
    -- impatient.nvim: Speed up loading Lua modules in Neovim to improve startup time.
    use 'lewis6991/impatient.nvim'

    -- Plugin and Packages Management for Neovim
    use 'wbthomason/packer.nvim'

    -- NodeJs Packages Management
    use {
      'vuki656/package-info.nvim',
      requires = { 'MunifTanjim/nui.nvim', opt = true },
      event = 'BufEnter package.json',
      config = function()
        require('package-info').setup()
      end,
    }

    -- FILES MANAGEMENT
    -- Git Decorations Integration
    use {
      'lewis6991/gitsigns.nvim',
      config = function()
        require 'kkokou.plugins.settings.cfg-gitsigns'
      end,
    }

    -- Git Commands Integration
    use 'tpope/vim-fugitive'

    -- Fuzzy Finder
    use {
      'nvim-telescope/telescope.nvim',
      requires = {
        'nvim-lua/plenary.nvim',
        -- { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
        'nvim-telescope/telescope-file-browser.nvim',
      },
      config = function()
        require 'kkokou.plugins.settings.cfg-telescope'
      end,
    }

    -- APPARENCE
    -- TreeSitter
    use {
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate',
      requires = {
        'JoosepAlviste/nvim-ts-context-commentstring', -- Dynamically set commentstring based on cursor location in file
      },
      config = function()
        require 'kkokou.plugins.settings.cfg-treesitter'
      end,
    }

    -- Autoclose and autorename html tag using Treesitter
    use {
      'windwp/nvim-ts-autotag',
      after = 'nvim-treesitter',
      config = function()
        require 'kkokou.plugins.settings.cfg-nvim-ts-autotag'
      end,
    }

    -- Treesitter Context
    use {
      'nvim-treesitter/nvim-treesitter-context',
      after = 'nvim-treesitter',
      config = function()
        require 'kkokou.plugins.settings.cfg-treesitter-context'
      end,
    }

    -- Status Line
    use {
      'nvim-lualine/lualine.nvim',
      after = 'nvim-lspconfig',
      disable = false,
      requires = { 'kyazdani42/nvim-web-devicons', opt = true },
      config = function()
        require 'kkokou.plugins.settings.cfg-lualine'
      end,
    }

    -- Color highlighter for Neovim
    use {
      -- 'norcalli/nvim-colorizer.lua',
      'NvChad/nvim-colorizer.lua',
      disable = true,
      config = function()
        require('colorizer').setup {
          filetypes = { '*', '!packer', '!dockerfile' },
          user_default_options = {
            tailwind = 'lsp',
            names = false,
            sass = { enable = true, parsers = { css = true } },
          },
          buftypes = {
            '*',
            -- exclude prompt and popup buftypes from highlight
            '!prompt',
            '!popup',
          },
        }
      end,
    }

    -- This plugin adds indentation guides to all lines (including empty lines).
    use {
      'lukas-reineke/indent-blankline.nvim',
      disable = false,
      event = 'VimEnter',
      config = function()
        require 'kkokou.plugins.settings.cfg-indent-blankline'
      end,
    }

    -- colorscheme
    use {
      'folke/tokyonight.nvim',
      disable = false,
      config = function()
        require 'kkokou.plugins.settings.cfg-tokyonight'
      end,
    }

    -- Zen-mode: Distraction-free coding
    use {
      'folke/zen-mode.nvim',
      disable = false,
      event = 'VimEnter',
      cmd = 'ZenMode',
      config = function()
        require('zen-mode').setup {}
      end,
    }

    -- Twilight: dims inactive portions of the code you're editing
    use {
      'folke/twilight.nvim',
      disable = false,
      event = 'VimEnter',
      config = function()
        require('twilight').setup {}
      end,
    }

    -- AUTO COMPLETION
    ------------------
    -- Native LSP
    use {
      'neovim/nvim-lspconfig',
      after = 'nvim-treesitter',
      requires = {
        'folke/neodev.nvim', -- Dev setup for init.lua and plugin development
        'ckipp01/stylua-nvim', -- wrapper around the Lua code formatter, StyLua
      },
      config = function()
        require 'kkokou.plugins.settings.cfg-lspconfig'
      end,
    }

    use {
      'j-hui/fidget.nvim',
      event = 'VimEnter',
      config = function()
        require('fidget').setup {
          window = {
            blend = 0, -- &winblend for the window
          },
        }
      end,
    }

    -- null-ls.nvim
    use {
      'jose-elias-alvarez/null-ls.nvim',
      requires = { 'nvim-lua/plenary.nvim' },
      config = function()
        require 'kkokou.plugins.settings.cfg-null-ls'
      end,
    }

    -- Completion Engine Plugin
    use {
      'hrsh7th/nvim-cmp',
      requires = {
        -- Snippets
        {
          'L3MON4D3/LuaSnip',
          requires = { 'rafamadriz/friendly-snippets' },
          config = function()
            require 'kkokou.plugins.settings.cfg-luasnip'
          end,
        },
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-nvim-lua',
        'hrsh7th/cmp-buffer',
        'saadparwaiz1/cmp_luasnip',
        'hrsh7th/cmp-path',
        'ray-x/cmp-treesitter',
        'f3fora/cmp-spell',
        'hrsh7th/cmp-nvim-lsp-signature-help',
      },
      config = function()
        require 'kkokou.plugins.settings.cfg-cmp'
      end,
    }

    -- Autopairs for Neovim
    use {
      'windwp/nvim-autopairs',
      config = function()
        require 'kkokou.plugins.settings.cfg-autopairs'
      end,
    }

    -- OTHERS
    ---------
    -- Visualizes undo history and makes it easier to browse and switch between different undo branches
    use 'mbbill/undotree'

    -- Comment text in and out
    use {
      'numToStr/Comment.nvim',
      disable = false,
      config = function()
        require 'kkokou.plugins.settings.cfg-comment'
      end,
    }

    -- Surroundings
    use {
      'kylechui/nvim-surround',
      disable = false,
      config = function()
        require('nvim-surround').setup {}
      end,
    }

    -- EditorConfig for Vim
    use 'editorconfig/editorconfig-vim'

    -- Interaction with Databases
    use {
      'kristijanhusak/vim-dadbod-ui',
      event = 'VimEnter',
      opt = true,
      disable = false,
      requires = {
        'tpope/vim-dadbod',
        'kristijanhusak/vim-dadbod-completion',
        'hrsh7th/nvim-cmp',
      },
      config = function()
        require 'kkokou.plugins.settings.cfg-vim-dadbod-ui'
      end,
    }

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
      require('packer').sync()
    end
  end,
  config = {
    compile_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim/plugin/packer_compiled.lua',
  },
}
