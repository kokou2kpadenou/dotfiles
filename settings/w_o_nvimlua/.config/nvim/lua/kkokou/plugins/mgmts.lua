return {
  -- Lazy.nvim
  { 'folke/lazy.nvim', version = '*' },

  -- NodeJs Packages Management
  {
    'vuki656/package-info.nvim',
    dependencies = { 'MunifTanjim/nui.nvim' },
    event = 'BufEnter package.json',
    config = true,
  },

  -- Git Decorations Integration
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    enabled = true,
    opts = {
      -- signs = {
      --   add = { text = '+' },
      --   change = { text = '│' },
      --   delete = { text = '_' },
      --   topdelete = { text = '‾' },
      --   changedelete = { text = '~' },
      --   untracked = { text = '┆' },
      -- },
      signs = {
        add          = { text = '+' },
        change       = { text = '┃' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
      },

      signs_staged = {
        add          = { text = '+' },
        change       = { text = '┃' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
      },

      on_attach = function(bufnr)
        local gitsigns = require('gitsigns')

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal({']c', bang = true})
          else
            gitsigns.nav_hunk('next')
          end
        end)

        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal({'[c', bang = true})
          else
            gitsigns.nav_hunk('prev')
          end
        end)

        -- Actions
        map('n', '<leader>hs', gitsigns.stage_hunk)
        map('n', '<leader>hr', gitsigns.reset_hunk)

        map('v', '<leader>hs', function()
          gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end)

        map('v', '<leader>hr', function()
          gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end)

        map('n', '<leader>hS', gitsigns.stage_buffer)
        map('n', '<leader>hR', gitsigns.reset_buffer)
        map('n', '<leader>hp', gitsigns.preview_hunk)
        map('n', '<leader>hi', gitsigns.preview_hunk_inline)

        map('n', '<leader>hb', function()
          gitsigns.blame_line({ full = true })
        end)

        map('n', '<leader>hd', gitsigns.diffthis)

        map('n', '<leader>hD', function()
          gitsigns.diffthis('~')
        end)

        map('n', '<leader>hQ', function() gitsigns.setqflist('all') end)
        map('n', '<leader>hq', gitsigns.setqflist)

        -- Toggles
        map('n', '<leader>tb', gitsigns.toggle_current_line_blame)
       -- map('n', '<leader>td', gitsigns.toggle_deleted)
        map('n', '<leader>tw', gitsigns.toggle_word_diff)

        -- Text object
        map({'o', 'x'}, 'ih', gitsigns.select_hunk)
      end,
    },
  },

  -- Git Commands Integration
  {
    enabled = false,
    'tpope/vim-fugitive',
  },

  -- Fuzzy Finder
  {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
      'nvim-telescope/telescope-file-browser.nvim',
    },
    version = false,
    opts = {
      defaults = {
        file_ignore_patterns = { 'node_modules', '.git' },
        color_devicons = true,
      },
      -- extensions = {
      --   fzf = {
      --     fuzzy = true,
      --     override_generic_sorter = true,
      --     override_file_sorter = true,
      --     case_mode = 'smart_case',
      --   }
      -- }
    },
    config = function(_, opts)
      require('telescope').setup(opts)
      require('telescope').load_extension 'file_browser'
    end,
  },

  -- Oil - File manager
  {
    'stevearc/oil.nvim',
    opts = function()
      local git_ignored = setmetatable({}, {
        __index = function(self, key)
          local proc = vim.system({ 'git', 'ls-files', '--ignored', '--exclude-standard', '--others', '--directory' }, {
            cwd = key,
            text = true,
          })
          local result = proc:wait()
          local ret = {}
          if result.code == 0 then
            for line in vim.gsplit(result.stdout, '\n', { plain = true, trimempty = true }) do
              -- Remove trailing slash
              line = line:gsub('/$', '')
              table.insert(ret, line)
            end
          end

          rawset(self, key, ret)
          return ret
        end,
      })

      return {
        columns = vim.g.kkokou_oil_detail and { 'icon', 'permissions', 'size', 'mtime' } or { 'icon' },
        keymaps = {
          ['gd'] = {
            desc = 'Toggle file detail view',
            callback = function()
              vim.g.kkokou_oil_detail = not vim.g.kkokou_oil_detail
              if vim.g.kkokou_oil_detail then
                require('oil').set_columns { 'icon', 'permissions', 'size', 'mtime' }
              else
                require('oil').set_columns { 'icon' }
              end
            end,
          },
        },
        view_options = {
          is_hidden_file = function(name, _)
            -- dotfiles are always considered hidden
            if vim.startswith(name, '.') then
              return true
            end
            local dir = require('oil').get_current_dir()
            -- if no local directory (e.g. for ssh connections), always show
            if not dir then
              return false
            end
            -- Check if file is gitignored
            return vim.list_contains(git_ignored[dir], name)
          end,
        },
      }
    end,
    -- Optional dependencies
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    init = function()
      vim.g.kkokou_oil_detail = false
    end,
  },

  -- neo-tree.nvim
  {
    'nvim-neo-tree/neo-tree.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
      'MunifTanjim/nui.nvim',
    },
    opts = {

      filesystem = {
        filtered_items = {
          hide_by_name = {
            'node_modules',
          },
        },
      },
    },
    cmd = 'Neotree',
  },
}
