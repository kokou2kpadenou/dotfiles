vim.opt.list = false

vim.keymap.set("n", "q", function()
  vim.cmd("bd")
end, { buffer = true, silent = true })
