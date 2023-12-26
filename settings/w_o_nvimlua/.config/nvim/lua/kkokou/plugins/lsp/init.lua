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
        tag = 'v1.1.0',
        opts = {
          -- FIXME: Failed to make fidget window transparent. Will try to fix it later.

          -- Options related to the notification window and buffer
          window = {
            normal_hl = '', -- Base highlight group in the notification window
            winblend = 0, -- Background color opacity in the notification window
            border = 'rounded', -- Border around the notification window
            zindex = 45, -- Stacking priority of the notification window
            max_width = 0, -- Maximum width of the notification window
            max_height = 0, -- Maximum height of the notification window
            x_padding = 1, -- Padding from right edge of window boundary
            y_padding = 1, -- Padding from bottom edge of window boundary
            align = 'bottom', -- How to align the notification window
            relative = 'editor', -- What the notification window position is relative to
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
      local signs = { Error = ' ', Warn = ' ', Hint = ' ', Info = ' ' }
      for type, icon in pairs(signs) do
        local hl = 'DiagnosticSign' .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end

      -- Diagnostic keymaps
      vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
      vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

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

          if vim.lsp.inlay_hint then
            vim.keymap.set('n', '<space>ih', function()
              vim.lsp.inlay_hint(0, nil)
            end, opts '[i]nlay [h]int')
          end
        end,
      })

      -- Add additional capabilities supported by nvim-cmp
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      local default_lsp_config = {
        capabilities = capabilities,
      }

      -- IMPORTANT: make sure to setup neodev BEFORE lspconfig for sumneko_lua
      require('neodev').setup {
        -- add any options here, or leave empty to use the default settings
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
