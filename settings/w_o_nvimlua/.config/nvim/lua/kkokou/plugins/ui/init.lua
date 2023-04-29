return {
  -- Autoclose and autorename html tag using Treesitter
  {
    'windwp/nvim-ts-autotag',
    event = 'VeryLazy',
    opts = {
      filetypes = {
        'html',
        'javascript',
        'typescript',
        'javascriptreact',
        'typescriptreact',
        'svelte',
        'vue',
        'tsx',
        'jsx',
        'rescript',
        'xml',
        'php',
        'markdown',
        'glimmer',
        'handlebars',
        'hbs',
        'astro',
      },
    },
    config = true,
  },

  -- Treesitter Context
  {
    'nvim-treesitter/nvim-treesitter-context',
    event = 'VeryLazy',
    opts = {
      enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
      max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
      trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
      patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
        -- For all filetypes
        -- Note that setting an entry here replaces all other patterns for this entry.
        -- By setting the 'default' entry below, you can control which nodes you want to
        -- appear in the context window.
        default = {
          'class',
          'function',
          'method',
          'for',
          'while',
          'if',
          'switch',
          'case',
        },
        -- Patterns for specific filetypes
        -- If a pattern is missing, *open a PR* so everyone can benefit.
        tex = {
          'chapter',
          'section',
          'subsection',
          'subsubsection',
        },
        rust = {
          'impl_item',
          'struct',
          'enum',
        },
        scala = {
          'object_definition',
        },
        vhdl = {
          'process_statement',
          'architecture_body',
          'entity_declaration',
        },
        markdown = {
          'section',
        },
        elixir = {
          'anonymous_function',
          'arguments',
          'block',
          'do_block',
          'list',
          'map',
          'tuple',
          'quoted_content',
        },
      },
      exact_patterns = {
        -- Example for a specific filetype with Lua patterns
        -- Treat patterns.rust as a Lua pattern (i.e "^impl_item$" will
        -- exactly match "impl_item" only)
        -- rust = true,
      },

      -- [!] The options below are exposed but shouldn't require your attention,
      --     you can safely ignore them.

      zindex = 20, -- The Z-index of the context window
      mode = 'cursor', -- Line used to calculate context. Choices: 'cursor', 'topline'
      -- Separator between context and content. Should be a single character string, like '-'.
      -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
      separator = nil,
    },
    config = function(_, opts)
      require('treesitter-context').setup(opts)
    end,
  },

  -- Status Line
  {
    'nvim-lualine/lualine.nvim',
    -- event = 'VeryLazy',
    -- enabled = false,
    lazy = false,
    priority = 900,
    dependencies = { 'kyazdani42/nvim-web-devicons', 'Exafunction/codeium.vim', 'Exafunction/codeium.vim' },
    config = function()
      require 'kkokou.plugins.settings.cfg-lualine'
    end,
  },

  -- This plugin adds indentation guides to all lines (including empty lines).
  {
    'lukas-reineke/indent-blankline.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      space_char_blankline = ' ',
      show_current_context = true,
      show_current_context_start = true,
    },
  },

  -- Zen-mode: Distraction-free coding
  {
    'folke/zen-mode.nvim',
    cmd = 'ZenMode',
    dependencies = {
      -- Twilight: dims inactive portions of the code you're editing
      {
        'folke/twilight.nvim',
        config = true,
      },
    },
    config = function()
      require('zen-mode').setup {}
    end,
  },

  -- Color highlighter for Neovim
  {
    'brenoprata10/nvim-highlight-colors',
    ft = {
      'html',
      'css',
      'scss',
      'astro',
      'vue',
      'svelte',
      'javascript',
      'javascriptreact',
      'typescript',
      'typescriptreact',
    },
    opts = {
      render = 'background', -- or 'foreground' or 'first_column'
      enable_named_colors = true,
      enable_tailwind = true,
    },
    config = true,
  },

  -- animations
  {
    'echasnovski/mini.animate',
    enabled = false,
    version = false,
    opts = {},
    config = function(_, opts)
      require('mini.animate').setup(opts)
    end,
  },

  -- neo-tree.nvim
  {
    'nvim-neo-tree/neo-tree.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- 'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
      'kyazdani42/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
      -- {
      --   -- only needed if you want to use the commands with "_with_window_picker" suffix
      --   's1n7ax/nvim-window-picker',
      --   tag = "v1.*",
      --   config = function()
      --     require'window-picker'.setup({
      --       autoselect_one = true,
      --       include_current = false,
      --       filter_rules = {
      --         -- filter using buffer options
      --         bo = {
      --           -- if the file type is one of following, the window will be ignored
      --           filetype = { 'neo-tree', "neo-tree-popup", "notify" },
      --
      --           -- if the buffer type is one of following, the window will be ignored
      --           buftype = { 'terminal', "quickfix" },
      --         },
      --       },
      --       other_win_hl_color = '#e35e4f',
      --     })
      --   end,
      -- }
    },
    cmd = 'Neotree',
    deactivate = function()
      vim.cmd [[Neotree close]]
    end,
    init = function()
      vim.g.neo_tree_remove_legacy_commands = 1
      if vim.fn.argc() == 1 then
        local stat = vim.loop.fs_stat(vim.fn.argv(0))
        if stat and stat.type == 'directory' then
          require 'neo-tree'
        end
      end
    end,

    opts = {
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = true,
      },
      window = {
        mappings = {
          ['<space>'] = 'none',
        },
      },
    },
  },
}
