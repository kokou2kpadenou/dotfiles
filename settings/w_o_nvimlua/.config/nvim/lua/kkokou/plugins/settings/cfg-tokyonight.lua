require('tokyonight').setup {
  style = 'storm', -- The theme comes in three styles, `storm`, a darker variant `night` and `day`
  transparent = true, -- Enable this to disable setting the background color
  terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
  styles = {
    -- Background styles. Can be "dark", "transparent" or "normal"
    sidebars = 'transparent', -- style for sidebars, see below
    floats = 'transparent', -- style for floating windows
  },
}

vim.api.nvim_cmd({
  cmd = 'colorscheme',
  args = { 'tokyonight' },
}, {})
