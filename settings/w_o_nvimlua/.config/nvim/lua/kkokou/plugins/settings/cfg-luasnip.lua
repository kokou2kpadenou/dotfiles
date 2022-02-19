--

local ls = require("luasnip")
local types = require("luasnip.util.types")

ls.config.set_config({
	history = true,
	-- Update more often, :h events for more info.
	updateevents = "TextChanged,TextChangedI",
	-- Snippets aren't automatically removed if their text is deleted.
	-- `delete_check_events` determines on which events (:h events) a check for
	-- deleted snippets is performed.
	-- This can be especially useful when `history` is enabled.
	delete_check_events = "TextChanged",
	ext_opts = {
		[types.choiceNode] = {
			active = {
				virt_text = { { "choiceNode", "Comment" } },
			},
		},
	},
	-- treesitter-hl has 100, use something higher (default is 200).
	ext_base_prio = 300,
	-- minimal increase in priority.
	-- ext_prio_increase = 1,
	enable_autosnippets = true,
	-- mapping for cutting selected text so it's usable as SELECT_DEDENT,
	-- SELECT_RAW or TM_SELECTED_TEXT (mapped via xmap).
	-- store_selection_keys = "<Tab>",
	-- luasnip uses this function to get the currently active filetype. This
	-- is the (rather uninteresting) default, but it's possible to use
	-- eg. treesitter for getting the current filetype by setting ft_func to
	-- require("luasnip.extras.filetype_functions").from_cursor (requires
	-- `nvim-treesitter/nvim-treesitter`). This allows correctly resolving
	-- the current filetype in eg. a markdown-code block or `vim.cmd()`.
	ft_func = function()
		return vim.split(vim.bo.filetype, ".", true)
	end,
})

-- Load friendly-snippets
require('luasnip.loaders.from_vscode').lazy_load {
  paths = { vim.fn.stdpath 'data' .. '/site/pack/packer/start/friendly-snippets' },
} -- You can pass { paths = "./my-snippets/"} as well

-- Mapping
local function prequire(...)
  local status, lib = pcall(require, ...)
  if status then
    return lib
  end
  return nil
end

local luasnip = prequire 'luasnip'
local cmp = prequire 'cmp'

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
  local col = vim.fn.col '.' - 1
  if col == 0 or vim.fn.getline('.'):sub(col, col):match '%s' then
    return true
  else
    return false
  end
end

_G.tab_complete = function()
  if cmp and cmp.visible() then
    cmp.select_next_item()
  elseif luasnip and luasnip.expand_or_jumpable() then
    return t '<Plug>luasnip-expand-or-jump'
  elseif check_back_space() then
    return t '<Tab>'
  else
    cmp.complete()
  end
  return ''
end
_G.s_tab_complete = function()
  if cmp and cmp.visible() then
    cmp.select_prev_item()
  elseif luasnip and luasnip.jumpable(-1) then
    return t '<Plug>luasnip-jump-prev'
  else
    return t '<S-Tab>'
  end
  return ''
end

vim.api.nvim_set_keymap('i', '<C-F>', 'v:lua.tab_complete()', { expr = true })
vim.api.nvim_set_keymap('s', '<C-F>', 'v:lua.tab_complete()', { expr = true })
vim.api.nvim_set_keymap('i', '<C-B>', 'v:lua.s_tab_complete()', { expr = true })
vim.api.nvim_set_keymap('s', '<C-B>', 'v:lua.s_tab_complete()', { expr = true })
vim.api.nvim_set_keymap('i', '<C-E>', '<Plug>luasnip-next-choice', {})
vim.api.nvim_set_keymap('s', '<C-E>', '<Plug>luasnip-next-choice', {})
