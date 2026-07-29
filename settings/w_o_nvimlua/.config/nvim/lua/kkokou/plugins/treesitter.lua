return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      
      require('nvim-treesitter').setup {
        install_dir = vim.fn.stdpath('data') .. '/site'
      }
      -- Install Parses and Queries
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
      }):wait(300000)

      -- Globally enable Treesitter syntax highlighting via Autocmd
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
        end,
      })

      -- Enable native folding using Treesitter expressions
      vim.wo.foldmethod = "expr"
      vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    end,
  },
}

