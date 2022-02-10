return function()
	-- return {
	-- 	settings = {
	-- 		Lua = {
	-- 			runtime = {
	-- 				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
	-- 				version = "LuaJIT",
	-- 			},
	-- 			diagnostics = {
	-- 				-- Get the language server to recognize the `vim` global
	-- 				globals = { "vim" },
	-- 			},
	-- 			workspace = {
	-- 				-- Make the server aware of Neovim runtime files
	-- 				library = vim.api.nvim_get_runtime_file("", true),
	-- 			},
	-- 			-- Do not send telemetry data containing a randomized but unique identifier
	-- 			telemetry = { enable = false },
	-- 		},
	-- 	},
	-- }


-- lspconfig.sumneko_lua.setup(luadev)
local luadevconfig = {
  library = {
    vimruntime = true, -- runtime path
    types = true, -- full signature, docs and completion of vim.api, vim.treesitter, vim.lsp and others
    plugins = true, -- installed opt or start plugins in packpath
    -- you can also specify the list of plugins to make available as a workspace library
    -- plugins = { "nvim-treesitter", "plenary.nvim", "telescope.nvim" },
  },
  runtime_path = true, -- enable this to get completion in require strings. Slow!
  -- pass any additional options that will be merged in the final lsp config
  lspconfig = {
    -- cmd = {"lua-language-server"},
    -- on_attach = ...
    -- on_attach = on_attach,
    -- capabilities = capabilities,
    commands = {
      Format = {
        function()
          require('stylua-nvim').format_file()
        end,
      },
    },
    settings = {
      Lua = {
        -- runtime = {
        --   -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        --   version = 'LuaJIT',
        --   -- Setup your lua path
        --   path = runtime_path,
        -- },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = { 'use' },
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          -- library = vim.api.nvim_get_runtime_file('', true),
          preloadFileSize = 350,
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
          enable = false,
        },
      },
    },
  },
}

 return require('lua-dev').setup(luadevconfig)

end
