return {

  -- INFO: In progress

  -- nvim-dap
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      {
        'rcarriga/nvim-dap-ui',
        opts = {},
        config = function()
          local dap, dapui = require 'dap', require 'dapui'
          dap.listeners.after.event_initialized['dapui_config'] = function()
            dapui.open()
          end
          dap.listeners.before.event_terminated['dapui_config'] = function()
            dapui.close()
          end
          dap.listeners.before.event_exited['dapui_config'] = function()
            dapui.close()
          end
        end,
      },
      {
        'theHamsta/nvim-dap-virtual-text',
        opts = {},
      },
    },
    opts = {},
    config = function()
      -- TODO: Set Go, Javascript, Typescript adapter
      local dap = require 'dap'

      dap.adapters['pwa-node'] = {
        type = 'server',
        host = '127.0.0.1',
        port = 8123,
        executable = {
          command = 'js-debug-adapter',
        },
      }

      for _, language in ipairs { 'typescript', 'javascript' } do
        dap.configurations[language] = {
          {
            type = 'pwa-node',
            request = 'launch',
            name = 'Launch file',
            program = '${file}',
            cwd = '${workspaceFolder}',
            runtimeExecutable = 'node',
          },
        }
      end

      -- stylua: ignore
      local custom_commands = {
        DAPBreakpointCondition = function() dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ') end,
        DAPBreakpoint = function() dap.toggle_breakpoint() end,
        DAPContinue = function() dap.continue() end,
        DAPRunToCursor = function() dap.run_to_cursor() end,
        DAPGoTo = function() dap.goto_() end,
        DAPStepInto = function() dap.step_into() end,
        DAPDown = function() dap.down() end,
        DAPUp = function() dap.up() end,
        DAPRunLast = function() dap.run_last() end,
        DAPStepOut = function() dap.step_out() end,
        DAPStepOver = function() dap.step_over() end,
        DAPPause = function() dap.pause() end,
        DAPReplToggle = function() dap.repl.toggle() end,
        DAPSession = function() dap.session() end,
        DAPTerminate = function() dap.terminate() end,
        DAPHover = function() require('dap.ui.widgets').hover() end,
      }

      for command, func in pairs(custom_commands) do
        vim.api.nvim_create_user_command(command, func, { nargs = 0 })
      end
    end,
  },

  -- TODO: Replace Null-ls (archived) with an alternative.
  --
  -- null-ls.nvim
  {
    'jose-elias-alvarez/null-ls.nvim',

    event = { 'BufReadPre', 'BufNewFile' },

    dependencies = { 'nvim-lua/plenary.nvim' },

    opts = function()
      return {
        debug = false,
        log = {
          enable = false,
          level = 'warn',
          use_console = 'async',
        },
        sources = {
          require('null-ls').builtins.formatting.prettierd.with {
            filetypes = {
              'javascript',
              'javascriptreact',
              'typescript',
              'typescriptreact',
              'vue',
              'css',
              'scss',
              'less',
              'html',
              'json',
              'jsonc',
              'yaml',
              'markdown',
              'graphql',
              'handlebars',
              'astro',
            },
          },
          require('null-ls').builtins.formatting.stylua,
        },
      }
    end,
  },

  -- Autopairs for Neovim
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    opts = {
      fast_wrap = {},
    },
  },

  -- snippets
  {
    'L3MON4D3/LuaSnip',
    event = 'InsertEnter',
    dependencies = { 'rafamadriz/friendly-snippets', 'numToStr/Comment.nvim' },

    opts = function()
      local types = require 'luasnip.util.types'
      return {
        history = true,
        updateevents = 'TextChanged,TextChangedI',
        delete_check_events = 'TextChanged',
        ext_opts = {
          [types.choiceNode] = {
            active = {
              virt_text = { { '●', 'DiagnosticError' } },
            },
          },
          [types.insertNode] = {
            active = {
              virt_text = { { '●', 'DiagnosticHint' } },
            },
          },
        },
        ext_base_prio = 300,
        enable_autosnippets = true,
        ft_func = function()
          return vim.split(vim.bo.filetype, '.', { plain = true, trimempty = true })
        end,
      }
    end,
    config = function(_, opts)
      local ls = require 'luasnip'

      ls.config.setup(opts)
      -- Load friendly-snippets
      require('luasnip.loaders.from_vscode').lazy_load {
        -- paths = { vim.fn.stdpath 'data' .. '/site/pack/packer/start/friendly-snippets' },
      }

      ls.filetype_extend('javascript', { 'javascriptreact' })
      ls.filetype_extend('typescript', { 'typescriptreact' })

      require 'kkokou.settings.todo-comment-snip'
    end,
    keys = {
      {
        '<tab>',
        function()
          return require('luasnip').jumpable(1) and '<Plug>luasnip-jump-next' or '<tab>'
        end,
        expr = true,
        silent = true,
        mode = 'i',
      },
      {
        '<tab>',
        function()
          require('luasnip').jump(1)
        end,
        mode = 's',
      },
      {
        '<s-tab>',
        function()
          require('luasnip').jump(-1)
        end,
        mode = { 'i', 's' },
      },
    },
  },

  -- auto completion
  {
    'hrsh7th/nvim-cmp',
    version = false, -- last release is way too old
    event = {
      'InsertEnter',
      -- 'CmdlineEnter',
    },
    dependencies = {
      -- 'L3MON4D3/LuaSnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-buffer',
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-path',
      'ray-x/cmp-treesitter',
      'f3fora/cmp-spell',
      'hrsh7th/cmp-nvim-lsp-signature-help',
    },

    opts = function()
      local cmp = require 'cmp'

      local kind_icons = {
        Array = ' ',
        Boolean = ' ',
        Class = ' ',
        Color = ' ',
        Constant = ' ',
        Constructor = ' ',
        Copilot = ' ',
        Enum = ' ',
        EnumMember = ' ',
        Event = ' ',
        Field = ' ',
        File = ' ',
        Folder = ' ',
        Function = ' ',
        Interface = ' ',
        Key = ' ',
        Keyword = ' ',
        Method = ' ',
        Module = ' ',
        Namespace = ' ',
        Null = ' ',
        Number = ' ',
        Object = ' ',
        Operator = ' ',
        Package = ' ',
        Property = ' ',
        Reference = ' ',
        Snippet = ' ',
        String = ' ',
        Struct = ' ',
        Text = ' ',
        TypeParameter = ' ',
        Unit = ' ',
        Value = ' ',
        Variable = ' ',
      }

      -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline({ '/', '?' }, {
        -- mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer', keyword_length = 3 },
        },
      })

      return {
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },

        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },

        formatting = {
          format = function(entry, vim_item)
            require('colorizer-cmp').color_formater {} (entry, vim_item)

            -- Kind icons
            vim_item.kind = string.format('%s %s %s %s', '', kind_icons[vim_item.kind], vim_item.kind, '  ') -- This concatonates the icons with the name of the item kind
            -- Source
            vim_item.menu = ({
              buffer = '[buf]',
              nvim_lua = '[LUA]',
              nvim_lsp = '[LSP]',
              path = '[path]',
              luasnip = '[snip]',
              spell = '[spell]',
              treesitter = '[synx]',
              ['vim-dadbod-completion'] = '[DB]',
            })[entry.source.name]
            return vim_item
          end,
        },

        mapping = cmp.mapping.preset.insert {
          ['<C-n>'] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
          ['<C-p>'] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm { select = true }, -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        },

        sources = cmp.config.sources({
          { name = 'nvim_lua' },
          { name = 'treesitter' },
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'nvim_lsp_signature_help' },
        }, {
          { name = 'path' },
          { name = 'buffer', keyword_length = 5 },
          { name = 'spell' },
        }),
      }
    end,
  },
}
