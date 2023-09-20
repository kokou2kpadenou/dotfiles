-- TODO: Clean up
return {
  -- the colorscheme should be available when starting Neovim
  {
    'folke/tokyonight.nvim',
    -- lazy = false,             -- make sure we load this during startup if it is your main colorscheme
    -- priority = 1000,          -- make sure to load this before all the other start plugins
    keys = '<leader>cc',
    opts = {
      style = 'storm',        -- The theme comes in three styles, `storm`, a darker variant `night` and `day`
      transparent = true,     -- Enable this to disable setting the background color
      terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
      styles = {
        -- Background styles. Can be "dark", "transparent" or "normal"
        sidebars = 'transparent', -- style for sidebars, see below
        floats = 'transparent',   -- style for floating windows
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
      flavour = 'mocha', -- latte, frappe, macchiato, mocha
      background = {     -- :h background
        light = 'latte',
        dark = 'mocha',
      },
      transparent_background = true,
      show_end_of_buffer = false, -- show the '~' characters after the end of buffers
      term_colors = false,
      dim_inactive = {
        enabled = false,
        shade = 'dark',
        percentage = 0.15,
      },
      no_italic = false, -- Force no italic
      no_bold = false,   -- Force no bold
      styles = {
        comments = { 'italic' },
        conditionals = { 'italic' },
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
      },
      color_overrides = {},
      custom_highlights = {},
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        telescope = true,
        notify = false,
        mini = false,
        -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
      },
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
