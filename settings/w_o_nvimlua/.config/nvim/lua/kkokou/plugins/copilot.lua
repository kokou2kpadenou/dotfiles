return {

  -- Copilot
  -- { 'github/copilot.vim' },
  {
    'zbirenbaum/copilot.lua',
    enabled = false,
    event = "InsertEnter",
    cmd = 'Copilot',
    -- build = ':Copilot auth',
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = true,
      },
    },
  },
}
