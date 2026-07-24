return {
  -- LAZYDEV
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

  -- LSPCONFIG
  {
    'neovim/nvim-lspconfig',

    event = { 'BufReadPre', 'BufNewFile' },

    dependencies = {

      { 'Bilal2453/luvit-meta', lazy = true }, -- optional `vim.uv` typings

      {                                        -- optional completion source for require statements and module annotations
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

      vim.lsp.config('html', {
        filetypes = { 'html', 'gotmpl' },
      })

      vim.lsp.enable({
        'astro',
        'bashls',
        'cssls',
        'cssmodules_ls',
        'dockerls',
        'emmet_ls',
        'eslint',
        'gopls',
        'html',
        'jsonls',
        'lua_ls',
        -- 'intelephense',
        'pyright',
        -- 'svelte',
        'tailwindcss',
        'taplo',
        'ts_ls',
        -- 'vuels',
        'yamlls'
      })

    end,
  },
}
