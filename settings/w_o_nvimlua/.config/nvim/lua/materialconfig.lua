vim.g.material_style = "palenight"

require('material').setup({
		contrast = {
			sidebars = false,
			floating_windows = false,
			line_numbers = false,
			sign_column = false,
			cursor_line = false,
			popup_menu = false
		},
		italics = {
			comments = true,
			strings = false,
			keywords = true,
			functions = true,
			variables = false
		},
		contrast_filetypes = {
			"terminal",
			"packer",
			"qf",
		},
		disable = {
			borders = false,
			background = true,
			term_colors = false,
			eob_lines = false
		},
})

vim.cmd 'colorscheme material'

--Lua:
vim.api.nvim_set_keymap('n', '<leader>mm', [[<Cmd>lua require('material.functions').toggle_style()<CR>]], { noremap = true, silent = true })
