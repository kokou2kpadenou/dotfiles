vim.pack.add({ "https://github.com/stevearc/conform.nvim" })

require("conform").setup({
  notify_on_error = false,
  format_on_save = function(bufnr)
    local disable_filetypes = { c = true, cpp = true }

    -- Disable with a global or buffer-local variable
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return
    end

    return {
      timeout_ms = 500,
      lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
    }
  end,

  formatters_by_ft = {
    bash = { 'beautysh' },
    css = { 'prettierd', 'prettier', stop_after_first = true },
    go = { 'goimports', 'gofmt' --[[ , 'injected' ]], },
    gotmpl = { 'prettierd', 'prettier', stop_after_first = true },
    html = { 'prettierd', 'prettier', stop_after_first = true },
    javascript = { 'prettierd', 'prettier', stop_after_first = true },
    javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
    json = { 'prettierd', 'prettier', stop_after_first = true },
    lua = { 'stylua' },
    markdown = { 'prettierd', 'prettier', stop_after_first = true },
    python = { 'isort', 'black' },
    scss = { 'prettierd', 'prettier', stop_after_first = true },
    sql = { 'sql_formatter' },
    toml = { 'taplo' },
    typescript = { 'prettierd', 'prettier', stop_after_first = true },
    typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
    yaml = { 'yamlfix' },
  },

})

-- formatexpr; gq
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
-- disable autoformat initially
vim.g.disable_autoformat = true

-- vim.api.nvim_create_user_command("FormatDisable", function(opts)
-- 	if opts.bang then
-- 		vim.b.disable_autoformat = true
-- 	else
-- 		vim.g.disable_autoformat = true
-- 	end
-- 	vim.notify("Autoformat disabled" .. (opts.bang and " (buffer)" or " (global)"), vim.log.levels.WARN)
-- end, { desc = "Disable autoformat-on-save", bang = true })
--
-- vim.api.nvim_create_user_command("FormatEnable", function()
-- 	vim.b.disable_autoformat = false
-- 	vim.g.disable_autoformat = false
-- 	vim.notify("Autoformat enabled", vim.log.levels.INFO)
-- end, { desc = "Re-enable autoformat-on-save" })
--
-- local auto_format = true
--
-- vim.keymap.set("n", "<leader>uf", function()
-- 	auto_format = not auto_format
-- 	if auto_format then
-- 		vim.cmd("FormatEnable")
-- 	else
-- 		vim.cmd("FormatDisable")
-- 	end
-- end, { desc = "Toggle Autoformat" })
--
-- vim.keymap.set({ "n", "v" }, "<leader>cn", "<cmd>ConformInfo<cr>", { desc = "Conform Info" })
--
-- vim.keymap.set({ "n", "v" }, "<leader>cf", function()
-- 	require("conform").format({ async = true }, function(err, did_edit)
-- 		if not err and did_edit then
-- 			vim.notify("Code formatted", vim.log.levels.INFO, { title = "Conform" })
-- 		end
-- 	end)
-- end, { desc = "Format buffer" })
--
-- vim.keymap.set({ "n", "v" }, "<leader>cF", function()
-- 	require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
-- end, { desc = "Format Injected Langs" })
