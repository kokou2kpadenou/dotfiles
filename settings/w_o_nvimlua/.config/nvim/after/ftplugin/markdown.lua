-- markdown ftplugin
-- vim.opt_local.colorcolumn = "101"
vim.opt.autoindent = true
vim.opt.linebreak = true
-- @TODOUA:
-- spell is not staying local for some reason
-- have to set nospell in other fts that are opened after a markdown
vim.opt_local.spell = true
vim.opt_local.conceallevel = 2

-- Markdown Preview in browser
-- For Glow, just type :Glow, I almost never use the :MarkdownPreview keymap, I type it.
-- vim.api.nvim_buf_set_keymap(0, "n", ",md", "<Plug>MarkdownPreview", { noremap = false })

-- toggle TS highlighting for markdown
-- vim.api.nvim_buf_set_keymap(0, "n", ",th", ":TSBufToggle highlight<CR>", { noremap = false })

-- wrap selection in markdown link
-- vim.api.nvim_buf_set_keymap(0, "v", ",wl", [[c[<c-r>"]()<esc>]], { noremap = false })

-- vim.api.nvim_exec(
--   [[
-- " arrows
-- iabbrev >> →
-- iabbrev << ←
-- iabbrev ^^ ↑
-- iabbrev VV ↓

-- " eunuch map
-- nmap <buffer><silent><localleader>rn :Rename<space>

-- " snippets for markdown
-- let b:vsnip_snippet_dir = expand('~/.config/nvim/snippets/')
-- ]],
--   false
-- )

-- vim.api.nvim_exec(
--   [[
-- augroup PersistMarkdownFolds
--   autocmd!
--   autocmd BufWinLeave *.md mkview
--   autocmd BufWinEnter *.md silent! loadview
-- augroup end
-- ]],
--   false
-- )

-- match and highlight hyperlinks
-- -- standalone
vim.fn.matchadd("matchURL", [[http[s]\?:\/\/[[:alnum:]%\/_#.-]*]])
vim.cmd "hi matchURL guifg=DodgerBlue"

-- Setup cmp setup buffer configuration - 👻 text off for markdown
-- local cmp = require "cmp"
-- cmp.setup.buffer {
--   sources = {
--     { name = "vsnip" },
--     { name = "spell" },
--     {
--       name = "buffer",
--       option = {
--         get_bufnrs = function()
--           -- @TODOUA: Trying out just populate from visible buffers. Keep?
--           local bufs = {}
--           for _, win in ipairs(vim.api.nvim_list_wins()) do
--             bufs[vim.api.nvim_win_get_buf(win)] = true
--           end
--           return vim.tbl_keys(bufs)
--         end,
--       },
--     },
--     { name = "path" },
--   },
--   experimental = {
--     ghost_text = false,
--   },
-- }
