--lualine

local function window()
  return vim.api.nvim_win_get_number(0)
end

local custom_fname = require('lualine.components.filename'):extend()
local highlight = require 'lualine.highlight'
local default_status_colors = { saved = '#228B22', modified = '#C70039' }

function custom_fname:init(options)
  custom_fname.super.init(self, options)
  self.status_colors = {
    saved = highlight.create_component_highlight_group(
      { bg = default_status_colors.saved },
      'filename_status_saved',
      self.options
    ),
    modified = highlight.create_component_highlight_group(
      { bg = default_status_colors.modified },
      'filename_status_modified',
      self.options
    ),
  }
  if self.options.color == nil then
    self.options.color = ''
  end
end

function custom_fname:update_status()
  local data = custom_fname.super.update_status(self)
  data = highlight.component_format_highlight(
    vim.bo.modified and self.status_colors.modified or self.status_colors.saved
  ) .. data
  return data
end

require('lualine').setup {
  options = {
    icons_enabled = true,
    -- theme = 'material-nvim',
    theme = 'material-stealth',
    section_separators = { left = '', right = '' },
    component_separators = { left = '', right = '' },
    disabled_filetypes = {},
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch' },
    -- lualine_c = {'filename'},
    lualine_c = { window, custom_fname },
    lualine_x = { 'encoding', 'fileformat', 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { 'filename' },
    lualine_x = { 'location' },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  extensions = {},
}
