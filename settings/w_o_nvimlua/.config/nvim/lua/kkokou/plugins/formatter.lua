-- Conform - Lightweight yet powerful formatter plugin for Neovim
return {
  {
    'stevearc/conform.nvim',
    -- lazy = false,
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<space>f',
        function()
          require('conform').format { async = true, lsp_fallback = true }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    -- This will provide type hinting with LuaLS
    ---@module "conform"
    ---@type conform.setupOpts
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        local disable_filetypes = { c = true, cpp = true }

        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end

        return {
          timeout_ms = 500,
          lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
        }
      end,

      formatters_by_ft = {
        bash = { 'beautysh' },
        css = { 'prettierd', 'prettier', stop_after_first = true },
        go = { 'goimports', 'gofmt' --[[ , 'injected' ]], },
        gotmpl = { 'prettierd', 'prettier', stop_after_first = true },
        html = { 'prettierd', 'prettier', stop_after_first = true },
        javascript = { 'prettierd', 'prettier', stop_after_first = true },
        javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
        json = { 'prettierd', 'prettier', stop_after_first = true },
        lua = { 'stylua' },
        markdown = { 'prettierd', 'prettier', stop_after_first = true },
        python = { 'isort', 'black' },
        scss = { 'prettierd', 'prettier', stop_after_first = true },
        sql = { 'sql_formatter' },
        toml = { 'taplo' },
        typescript = { 'prettierd', 'prettier', stop_after_first = true },
        typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
        yaml = { 'yamlfix' },
      },

      -- formatters = {
      --   injected = {
      --     -- Set the options field
      --     options = {
      --       -- Set individual option values
      --       ignore_errors = true,
      --       lang_to_formatters = {
      --         sql = { 'sql_formatter' },
      --       },
      --     },
      --   },
      -- },
    },
    init = function()
      -- formatexpr; gq
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
      -- disable autoformat initially
      vim.g.disable_autoformat = true
    end,
  },
}
