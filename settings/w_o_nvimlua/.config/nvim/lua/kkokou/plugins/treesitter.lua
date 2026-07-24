return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      -- local configs = require("nvim-treesitter")

      -- 1. Initialize the plugin directory
      -- configs.setup({
      --   install_dir = vim.fn.stdpath("data") .. "/site",
      -- })

      -- 2. Declaratively install your preferred language parsers
      require('nvim-treesitter').install({
        'astro',
        'bash',
        'comment',
        'css',
        'dart',
        'dockerfile',
        'go',
        'gomod',
        'gosum',
        'gotmpl',
        'gowork',
        'html',
        'javascript',
        'jsdoc',
        'json',
        'lua',
        'markdown',
        'markdown_inline',
        'php',
        'phpdoc',
        'python',
        'scss',
        'sql',
        'svelte',
        'toml',
        'tsx',
        'typescript',
        'vue',
        'yaml',
      })

      -- 3. Globally enable Treesitter syntax highlighting via Autocmd
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
        end,
      })

      -- 4. Enable native folding using Treesitter expressions
      vim.wo.foldmethod = "expr"
      vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    end,
  },
}

