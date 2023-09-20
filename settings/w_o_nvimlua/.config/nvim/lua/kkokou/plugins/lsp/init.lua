return {
  -- Native LSP
  {
    'neovim/nvim-lspconfig',

    event = { 'BufReadPre', 'BufNewFile' },

    dependencies = {
      'folke/neodev.nvim',   -- Dev setup for init.lua and plugin development
      'ckipp01/stylua-nvim', -- wrapper around the Lua code formatter, stylua

      -- fidget: Standalone UI for nvim-lsp progress. Eye candy for the impatient.
      {
        'j-hui/fidget.nvim',
        tag = 'legacy',
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
          vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

          -- Buffer local mappings.
          -- See `:help vim.lsp.*` for documentation on any of the below functions
          local opts = { buffer = ev.buf }
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
          vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
          vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
          vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
          vim.keymap.set('n', '<space>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, opts)
          vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
          vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
          vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
          vim.keymap.set('n', '<space>f', function()
            vim.lsp.buf.format { async = true }
          end, opts)
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
      local servers = require 'kkokou.plugins.lsp.servers' (on_attach, capabilities)

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
