return {
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    -- keys = '<leader>cc',
    opts = {
      style = 'storm',
      transparent = true,
      terminal_colors = true,
      styles = {
        sidebars = 'transparent',
        floats = 'transparent',
      },
    },
    config = function(_, opts)
      require('tokyonight').setup(opts)

      -- load the colorscheme here
      vim.api.nvim_cmd({ cmd = 'colorscheme', args = { 'tokyonight' } }, {})

      local function cycleFavoriteColorScheme(colors, current)
        if #colors == 0 then
          print 'List empty or list cycled without a valid colorscheme.'
          return
        end

        local nextColor = require('kkokou.utils.unofficial').getNextColor(colors, current)

        local success, _ = pcall(function()
          vim.cmd.colorscheme(nextColor)
        end)

        if success then
          print(vim.g.colors_name .. ' set as the current colorscheme')
        else
          print(nextColor .. ' does not exist.')
          cycleFavoriteColorScheme(
            require('kkokou.utils.unofficial').removeElementFromTable(colors, current),
            nextColor
          )
        end
      end

      vim.keymap.set('n', '<leader>cc', function()
        -- Define colorschemes to loop through with keymap
        local colorschemesToLoop = { 'tokyonight', 'catppuccin', 'bluloco', 'sorbet','darkblue' }

        cycleFavoriteColorScheme(colorschemesToLoop, vim.g.colors_name)
      end, { silent = true })
    end,
  },

  -- Catppuccin
  {
    'catppuccin/nvim',
    lazy = true,
    name = 'catppuccin',
    opts = {
      transparent_background = true,
    },
  },

  -- Bluloco
  {
    'uloco/bluloco.nvim',
    lazy = true,
    name = 'bluloco',
    dependencies = { 'rktjmp/lush.nvim' },
    opts = {
      style = 'dark',
      transparent = true,
      italics = true,
    },
  },
}
