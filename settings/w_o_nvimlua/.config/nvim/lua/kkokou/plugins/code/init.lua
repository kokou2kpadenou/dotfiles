return {
  -- Native LSP
  {
    'neovim/nvim-lspconfig',

    event = { 'BufReadPre', 'BufNewFile' },

    dependencies = {
      'folke/neodev.nvim', -- Dev setup for init.lua and plugin development
      'ckipp01/stylua-nvim', -- wrapper around the Lua code formatter, stylua

      -- fidget: Standalone UI for nvim-lsp progress. Eye candy for the impatient.
      {
        'j-hui/fidget.nvim',
        opts = {

          window = {
            blend = 0, -- &winblend for the window
          },
        },
      },
    },

    config = function()
      -- Diagnostic Settings
      ----------------------
      vim.diagnostic.config {
        virtual_text = false,
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = { border = 'rounded' },
      }

      -- Change diagnostic symbols in the sign column (gutter)
      local signs = { Error = ' ', Warn = ' ', Hint = ' ', Info = ' ' }
      for type, icon in pairs(signs) do
        local hl = 'DiagnosticSign' .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end

      -- Diagnostic keymaps
      local opts = { noremap = true, silent = true }
      vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
      vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)

      -- LSP Settings
      ---------------
      local lspconfig = require 'lspconfig'

      vim.lsp.set_log_level 'error' -- 'trace', 'debug', 'info', 'warn', 'error'

      local on_attach = function(_, bufnr)
        -- Enable completion triggered by <c-x><c-o>
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- Mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local bufopts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
        vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
        vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
        vim.keymap.set('n', '<space>wl', function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, bufopts)
        vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
        vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
        vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
        vim.keymap.set('n', '<space>f', vim.lsp.buf.format, bufopts)
      end

      -- nvim-cmp supports additional completion capabilities
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

      local default_lsp_config = {
        on_attach = on_attach,
        capabilities = capabilities,
        flags = {
          debounce_text_changes = 200,
          allow_incremental_sync = true,
        },
      }

      -- IMPORTANT: make sure to setup neodev BEFORE lspconfig for sumneko_lua
      require('neodev').setup {
        -- add any options here, or leave empty to use the default settings
      }

      -- Enable the following language servers
      local servers = require 'kkokou.plugins.settings.cfg-lspconfig.servers'(on_attach, capabilities)

      for lsp, lsp_config in pairs(servers) do
        local merged_config = vim.tbl_deep_extend('force', default_lsp_config, lsp_config)

        lspconfig[lsp].setup(merged_config)
      end

      vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' })
      vim.lsp.handlers['textDocument/signatureHelp'] =
        vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' })
    end,
  },

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
        },
      }
    end,
  },

  -- Autopairs for Neovim
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    opts = {
      disable_filetype = { 'TelescopePrompt', 'vim' },
      fast_wrap = {
        chars = { '{', '[', '(', '"', "'" },
        check_comma = true,
        end_key = '$',
        hightlight = 'Search',
        keys = 'qwertyuiopzxcvbnmasdfghjkl',
        map = '<M-e>',
        offset = 0, -- Offset from pattern match
        pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], '%s+', ''),
      },
    },
  },

  -- snippets
  {
    'L3MON4D3/LuaSnip',
    event = 'InsertEnter',
    dependencies = { 'rafamadriz/friendly-snippets' },
    -- enable = false,
    -- follow latest release.
    -- version = '<CurrentMajor>.*',
    -- install jsregexp (optional!).
    -- build = 'make install_jsregexp',

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
        paths = { vim.fn.stdpath 'data' .. '/site/pack/packer/start/friendly-snippets' },
      }

      ls.filetype_extend('javascript', { 'javascriptreact' })
      ls.filetype_extend('typescript', { 'typescriptreact' })
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
    -- event = {
    --   'InsertEnter', --[['CmdlineEnter']]
    -- },
    dependencies = {
      'L3MON4D3/LuaSnip', -- TODO: see if I can remove this in the futur
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-buffer',
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-path',
      'ray-x/cmp-treesitter',
      'f3fora/cmp-spell',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      -- TODO: add https://github.com/roobert/tailwindcss-colorizer-cmp.nvim
      -- { 'roobert/tailwindcss-colorizer-cmp.nvim', config = true, dev = true, branch = 'feature/tailwind-prefix' },
    },

    opts = function()
      local cmp = require 'cmp'

      local kind_icons = {
        Text = '',
        Method = '',
        Function = '',
        Constructor = '',
        Field = '',
        Variable = '',
        Class = 'ﴯ',
        Interface = '',
        Module = '',
        Property = 'ﰠ',
        Unit = '',
        Value = '',
        Enum = '',
        Keyword = '',
        Snippet = '',
        Color = '',
        File = '',
        Reference = '',
        Folder = '',
        EnumMember = '',
        Constant = '',
        Struct = '',
        Event = '',
        Operator = '',
        TypeParameter = '',
      }

      local rgbToHex = function(r, g, b)
        r = math.floor(r)
        g = math.floor(g)
        b = math.floor(b)
        return string.format('#%02x%02x%02x', r, g, b)
      end

      -- local hsl_to_hex = function(h, s, l)
      --   -- Convert HSL values to 0-1 range
      --   h = h / 360
      --   s = s / 100
      --   l = l / 100
      --
      --   -- Calculate RGB values
      --   local r, g, b
      --
      --   if s == 0 then
      --     r, g, b = l, l, l -- achromatic
      --   else
      --     local function hue_to_rgb(p, q, t)
      --       if t < 0 then
      --         t = t + 1
      --       end
      --       if t > 1 then
      --         t = t - 1
      --       end
      --       if t < 1 / 6 then
      --         return p + (q - p) * 6 * t
      --       end
      --       if t < 1 / 2 then
      --         return q
      --       end
      --       if t < 2 / 3 then
      --         return p + (q - p) * (2 / 3 - t) * 6
      --       end
      --       return p
      --     end
      --
      --     local q = l < 0.5 and l * (1 + s) or l + s - l * s
      --     local p = 2 * l - q
      --     r = hue_to_rgb(p, q, h + 1 / 3)
      --     g = hue_to_rgb(p, q, h)
      --     b = hue_to_rgb(p, q, h - 1 / 3)
      --   end
      --
      --   -- Convert RGB values to hexadecimal string
      --   return string.format('#%02x%02x%02x', r * 255, g * 255, b * 255)
      -- end

      local getTextColor = function(hexColor)
        -- Convert hex color code to RGB values
        local r = tonumber(string.sub(hexColor, 2, 3), 16)
        local g = tonumber(string.sub(hexColor, 4, 5), 16)
        local b = tonumber(string.sub(hexColor, 6, 7), 16)

        -- Calculate perceived brightness using the YIQ color space
        local brightness = (r * 299 + g * 587 + b * 114) / 1000

        -- Return white text color if the background is dark, black otherwise
        if brightness < 128 then
          return '#ffffff' -- white
        else
          return '#000000' -- black
        end
      end

      local colorBgFg = function(doc)
        -- return nil if doc nil
        if not doc then
          return nil, nil
        end

        -- Color is in hex #rrggbb
        if string.match(doc, '^#(%x%x%x%x%x%x)$') then
          return doc, getTextColor(doc)
        end

        -- Color is rgb(r, g, b) or rgba(r, g, b, a)
        local _, _, r, g, b, _ = string.find(doc, '^%a+%((%d+),%s*(%d+),%s*(%d+),?%s*(%d?%.?%d*)%)$')
        if r and g and b then
          local color = rgbToHex(tonumber(r), tonumber(g), tonumber(b))
          return color, getTextColor(color)
        end

        -- TODO: support for hsl
        -- local h, s, l, _ = doc:match 'hsla?%((%d+),%s*(%d+)%%%s*,%s*(%d+)%%%s*(,?%s*[%d.]+)?%s*%)'
        -- if h and s and l then
        --   local color = hsl_to_hex(tonumber(h), tonumber(s), tonumber(l))
        --   return color, getTextColor(color)
        -- end

        -- No color found
        return nil, nil
      end

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
            if vim_item.kind == 'Color' then
              local bg, fg = nil, nil
              -- if entry.completion_item.documentation then
              bg, fg = colorBgFg(entry.completion_item.documentation)

              if not bg then
                bg, fg = colorBgFg(vim_item.abbr)
              end

              if bg then
                local group = 'lsp_documentColor_cmp_' .. string.sub(bg, 2)
                if vim.fn.hlID(group) < 1 then
                  vim.api.nvim_set_hl(0, group, { fg = fg, bg = bg })
                end
                vim_item.kind_hl_group = group
              end
            end

            -- Kind icons
            vim_item.kind = string.format('%s %s', ' ' .. kind_icons[vim_item.kind] .. ' ', vim_item.kind .. ' ') -- This concatonates the icons with the name of the item kind
            -- Source
            vim_item.menu = ({
              buffer = '[buf]',
              nvim_lua = '[LUA]',
              nvim_lsp = '[LSP]',
              path = '[path]',
              luasnip = '[snip]',
              spell = '[spell]',
              treesitter = '[synx]',
            })[entry.source.name]
            return vim_item
            -- return require("tailwindcss-colorizer-cmp").formatter(entry, vim_item)
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
    config = function(_, opts)
      local cmp = require 'cmp'

      cmp.setup(opts)

      -- TODO: Set some configuration for specific filetype
      -- Set configuration for specific filetype.
      -- cmp.setup.filetype('gitcommit', {
      --   sources = cmp.config.sources({
      --     { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
      --   }, {
      --     { name = 'buffer' },
      --   }),
      -- })

      -- Use buffer source for `/`.
      cmp.setup.cmdline('/', {
        -- mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer', keyword_length = 3 },
        },
      })
    end,
  },

  -- Codeium - Code pilot alternative
  {
    'Exafunction/codeium.vim',
    lazy = true,
    init = function()
      vim.g.codeium_disable_bindings = 1
      vim.g.codeium_enabled = false
    end,
    config = function()
      -- stylua: ignore start
         vim.keymap.set('i', '<leader>g', function() return vim.fn['codeium#Accept']() end, { expr = true })
         vim.keymap.set('i', '<leader>;', function() return vim.fn['codeium#CycleCompletions'](1) end, { expr = true })
         vim.keymap.set('i', '<leader>,', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true })
         vim.keymap.set('i', '<leader>c', function() return vim.fn['codeium#Clear']() end, { expr = true })
      -- stylua: ignore end
    end,
  },

  --
}
