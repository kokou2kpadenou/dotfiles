-- Diagnostic Settings
----------------------
local signs = { Error = ' ', Warn = ' ', Hint = ' ', Info = ' ' }
vim.diagnostic.config {
  virtual_lines = true,
  virtual_text = false,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = signs.Error,
      [vim.diagnostic.severity.WARN] = signs.Warn,
      [vim.diagnostic.severity.HINT] = signs.Hint,
      [vim.diagnostic.severity.INFO] = signs.Info,
    },
  },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded' },
}
