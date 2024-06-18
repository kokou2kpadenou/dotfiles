return {
  -- Native LSP
  {
    'neovim/nvim-lspconfig',

    event = { 'BufReadPre', 'BufNewFile' },

    dependencies = {
      -- 'folke/neodev.nvim', -- Dev setup for init.lua and plugin development
      'ckipp01/stylua-nvim', -- wrapper around the Lua code formatter, stylua

      {
        'folke/lazydev.nvim',
        ft = 'lua', -- only load on lua files
        opts = {
          library = {
            'lazy.nvim',
            'luvit-meta/library',
            { path = 'luvit-meta/library', words = { 'vim%.uv' } },
          },
        },
      },

      { 'Bilal2453/luvit-meta', lazy = true }, -- optional `vim.uv` typings

      { -- optional completion source for require statements and module annotations
        'hrsh7th/nvim-cmp',
        opts = function(_, opts)
          opts.sources = opts.sources or {}
          table.insert(opts.sources, {
            name = 'lazydev',
            group_index = 0, -- set group index to 0 to skip loading LuaLS completions
          })
        end,
      },

      -- fidget: Standalone UI for nvim-lsp progress. Eye candy for the impatient.
      {
        'j-hui/fidget.nvim',
        opts = {
          notification = {
            window = {
              winblend = 0,
              border = 'rounded',
            },
          },
        },
        config = true,
      },

    },

    config = function()
      -- Diagnostic Settings
      ----------------------
      local signs = { Error = ' ', Warn = ' ', Hint = ' ', Info = ' ' }
      vim.diagnostic.config {
        virtual_text = false,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = signs.Error,
            [vim.diagnostic.severity.WARN] = signs.Warn,
            [vim.diagnostic.severity.HINT] = signs.Hint,
            [vim.diagnostic.severity.INFO] = signs.Info,
          },
        },
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = { border = 'rounded' },
      }

      -- LSP Settings
      ---------------
      local lspconfig = require 'lspconfig'

      vim.lsp.set_log_level 'error' -- 'trace', 'debug', 'info', 'warn', 'error'

      -- Use LspAttach autocommand to only map the following keys
      -- after the language server attaches to the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          -- Enable completion triggered by <c-x><c-o>
          -- vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

          -- Buffer local mappings.
          -- See `:help vim.lsp.*` for documentation on any of the below functions
          local opts = function(desc)
            local curr_opts = { buffer = ev.buf }
            if desc then
              curr_opts.desc = 'LSP: ' .. desc
            end
            return curr_opts
          end

          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts())
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts())
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts())
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts())
          vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts())
          vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts())
          vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts())
          vim.keymap.set('n', '<space>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, opts())
          vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts())
          vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts())
          vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts())
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts())
          vim.keymap.set('n', '<space>f', function()
            vim.lsp.buf.format { async = true }
          end, opts())

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          if client and client.server_capabilities.documentHighlightProvider then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = ev.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = ev.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- The following autocommand is used to enable inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
            vim.keymap.set('n', '<space>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = 0 })
            end, { buffer = ev.buf, desc = 'LSP: [T]oggle Inlay [H]ints' })
          end
        end,
      })

      -- Add additional capabilities supported by nvim-cmp
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      local default_lsp_config = {
        capabilities = capabilities,
      }

      -- Enable the following language servers
      local servers = require 'kkokou.plugins.lsp.servers'(capabilities)

      for lsp, lsp_config in pairs(servers) do
        local merged_config = vim.tbl_deep_extend('force', default_lsp_config, lsp_config)

        lspconfig[lsp].setup(merged_config)
      end

      vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' })
      vim.lsp.handlers['textDocument/signatureHelp'] =
        vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' })
    end,
  },
}
