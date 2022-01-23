vim.g.material_style = "darker"

require('material').setup({

	-- contrast = true, -- Enable contrast for sidebars, floating windows and popup menus like Nvim-Tree
	-- borders = false, -- Enable borders between verticaly split windows

	-- popup_menu = "dark", -- Popup menu style ( can be: 'dark', 'light', 'colorful' or 'stealth' )

	-- italics = {
	-- 	comments = false, -- Enable italic comments
	-- 	keywords = false, -- Enable italic keywords
	-- 	functions = false, -- Enable italic functions
	-- 	strings = false, -- Enable italic strings
	-- 	variables = false -- Enable italic variables
	-- },

	-- contrast_windows = { -- Specify which windows get the contrasted (darker) background
	-- 	"terminal", -- Darker terminal background
	-- 	"packer", -- Darker packer background
	-- 	"qf" -- Darker qf list background
	-- },

	-- text_contrast = {
	-- 	lighter = false, -- Enable higher contrast text for lighter style
	-- 	darker = false -- Enable higher contrast text for darker style
	-- },

	-- disable = {
	-- 	background = true, -- Prevent the theme from setting the background (NeoVim then uses your teminal background)
	-- 	term_colors = false, -- Prevent the theme from setting terminal colors
	-- 	eob_lines = false -- Hide the end-of-buffer lines
	-- },

	-- custom_highlights = {} -- Overwrite highlights with your own

  
		contrast = {
			sidebars = true,
			floating_windows = false,
			line_numbers = false,
			sign_column = false,
			cursor_line = true,
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
			borders = true,
			background = true,
			term_colors = false,
			eob_lines = false
		},
})

vim.cmd 'colorscheme material'
