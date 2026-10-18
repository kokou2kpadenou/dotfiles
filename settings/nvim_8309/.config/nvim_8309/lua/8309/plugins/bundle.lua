vim.pack.add({
  'https://github.com/mbbill/undotree', -- undotree plugin
  'https://github.com/windwp/nvim-autopairs',
  'https://github.com/windwp/nvim-ts-autotag',
  'https://github.com/kylechui/nvim-surround',
  'https://github.com/JoosepAlviste/nvim-ts-context-commentstring',
  'https://github.com/numToStr/Comment.nvim',
  'https://github.com/nvim-treesitter/nvim-treesitter-context',
  'https://github.com/lukas-reineke/indent-blankline.nvim',
  'https://github.com/folke/todo-comments.nvim',
  'https://github.com/MunifTanjim/nui.nvim', -- dependency for package-info.nvim
  'https://github.com/vuki656/package-info.nvim',
})

-- Autopairs for Neovim
require('nvim-autopairs').setup({
  fast_wrap = {},
})

-- Autoclose and autorename html tag using Treesitter
require('nvim-ts-autotag').setup({})

-- Surroundings
require('nvim-surround').setup({})

-- Comment text in and out
---@diagnostic disable-next-line: missing-fields
require('Comment').setup({
  pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
})

-- Treesitter Context
require('treesitter-context').setup({})

-- This plugin adds indentation guides to all lines (including empty lines).
require("ibl").setup({})

-- todo comments
require('todo-comments').setup({})


-- Lazy load on first insert mode entry (may not necessary)
-- local group = vim.api.nvim_create_augroup("package-infoLazyLoad", { clear = true })

-- vim.api.nvim_create_autocmd("BufEnter", {
--   pattern = "package.json",
--   group = group,
--   once = true,
--   callback = function()
    require("package-info").setup({})
--   end,
-- })
