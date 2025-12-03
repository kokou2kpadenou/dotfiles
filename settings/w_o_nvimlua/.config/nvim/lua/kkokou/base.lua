-- [[ Global variables ]]
-- Set the leader key
vim.g.mapleader = '\\'
vim.g.maplocalleader = '\\'

-- Desable providers
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_node_provider = 0

-- netrw
-- vim.g.netrw_banner = 0 -- disable annoying banner
-- vim.g.netrw_liststyle = 3 -- Tree style view
-- vim.g.netrw_bufsettings = 'noma nomod nonu nobl nowrap ro rnu'
-- vim.g.netrw_list_hide = (vim.fn['netrw_gitignore#Hide']())
--   .. [[,\(^\|\s\s\)\zs\.\S\+]]
--   .. [[,node_modules]]
--   .. [[,^dist$]]
--   .. [[,^tags$]]
--   .. [[,^out$]]
--   .. [[,^build$]] -- use .gitignore
-- vim.g.netrw_winsize = 35

-- Skip backwards compatibility routines and speed up loading
vim.g.skip_ts_context_commentstring_module = true

-- [[ Options ]]
vim.opt.completeopt = 'menu,menuone,noselect'
vim.opt.cursorline = true
vim.opt.errorbells = false
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.smartcase = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.lazyredraw = false
vim.opt.magic = true
vim.opt.updatetime = 300
vim.opt.shortmess = vim.opt.shortmess + 'c'
vim.opt.signcolumn = 'yes'
vim.opt.showcmd = true
vim.opt.scrolloff = 4

-- Sets how neovim will display certain whitespace characters in the editor.
vim.opt.list = true
vim.opt.listchars = { eol = '¬', tab = '>.', trail = '~', extends = '>', space = '⋅', precedes = '<' }

vim.opt.clipboard = 'unnamedplus'

vim.opt.termguicolors = true

vim.opt.foldenable = true
vim.opt.foldlevelstart = 90
vim.opt.foldnestmax = 5
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.foldcolumn = '1'

vim.opt.path = vim.opt.path + '**'
vim.opt.wildmenu = true
vim.opt.wildignore = vim.opt.wildignore + { '*/node_modules/*', '*/.next/*', '*/out/*', '*/dist/*', '*/tmp/*' }
vim.opt.hidden = true

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Save undo history
vim.opt.undofile = true

-- Disable mouse and scrolling
vim.opt.mouse = ''

vim.o.winborder = 'rounded'





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

-- LSP Settings
---------------
vim.lsp.log.set_level 'error'       -- 'trace', 'debug', 'info', 'warn', 'error'

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    -- vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = function(desc)
      local curr_opts = { buffer = ev.buf }
      if desc then
        curr_opts.desc = 'LSP: ' .. desc
      end
      return curr_opts
    end

    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts())
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts())
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts())
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts())
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts())
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts())
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts())
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts())
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts())
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts())
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts())
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts())
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts())

    -- The following two autocommands are used to highlight references of the
    -- word under your cursor when your cursor rests there for a little while.
    --    See `:help CursorHold` for information about when this is executed
    --
    -- When you move your cursor, the highlights will be cleared (the second autocommand).
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client.server_capabilities.documentHighlightProvider then
      local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = ev.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = ev.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
        end,
      })
    end

    -- The following autocommand is used to enable inlay hints in your
    -- code, if the language server you are using supports them
    --
    -- This may be unwanted, since they displace some of your code
    if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
      vim.keymap.set('n', '<space>th', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = 0 })
      end, { buffer = ev.buf, desc = 'LSP: [T]oggle Inlay [H]ints' })
    end
  end,
})
