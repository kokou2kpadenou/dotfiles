require('telescope').setup {
  defaults = {
    file_ignore_patterns = { 'node_modules', '.git' },
    color_devicons = true,
  },
}

require('telescope').load_extension 'fzf'
require('telescope').load_extension 'file_browser'
