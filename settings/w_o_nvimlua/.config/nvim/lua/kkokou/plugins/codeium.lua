return {

  -- Codeium - Copilot alternative
  {
    'Exafunction/codeium.vim',
    lazy = true,
    init = function()
      vim.g.codeium_disable_bindings = 1
      vim.g.codeium_enabled = false
    end,
    config = function()
      -- stylua: ignore start
      vim.keymap.set('i', '<leader>g', function() return vim.fn['codeium#Accept']() end, { expr = true })
      vim.keymap.set('i', '<leader>;', function() return vim.fn['codeium#CycleCompletions'](1) end, { expr = true })
      vim.keymap.set('i', '<leader>,', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true })
      vim.keymap.set('i', '<leader>c', function() return vim.fn['codeium#Clear']() end, { expr = true })
      -- stylua: ignore end
    end,
  },

}
