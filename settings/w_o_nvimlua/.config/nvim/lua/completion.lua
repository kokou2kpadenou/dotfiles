-- Setup nvim-cmp.

local cmp = require'cmp'

local lspkind = require "lspkind"
lspkind.init()

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },

  formatting = {
    format = lspkind.cmp_format {
      with_text = true,
      menu = {
        buffer = '[buf]',
        nvim_lsp = '[LSP]',
        nvim_lua = '[api]',
        path = '[path]',
        luasnip = '[snip]',
        cmdline = '[CMD]',
        spell = '[spell]',
        treesitter = '[synx]'
      },
    },
  },

  mapping = {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  },

  sources = {
    { name = 'nvim_lua' },
    { name = 'treesitter' },
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'path' },
    { name = 'buffer', keyword_length = 5 },
    { name = 'spell' },
  }
})


-- Use buffer source for `/`.
cmp.setup.cmdline('/', {
  sources = {
    { name = 'buffer', keyword_length = 3 }
  }
})

-- Use cmdline & path source for ':'.
-- cmp.setup.cmdline(':', {
--   sources = cmp.config.sources({
--     { name = 'path' }
--   }, {
--     { name = 'cmdline', keyword_length = 4 }
--   })
-- })
