vim.pack.add({
  {
    src = "https://github.com/saghen/blink.cmp",
    version = vim.version.range("^1"),
    data = {
      run = function(p)
        -- local blink_path = vim.fs.joinpath(vim.fn.stdpath('data'), 'site', 'pack', 'core', 'opt', 'blink.cmp')
        local path = p.path

        -- Notify start
        vim.notify("Fuzzy installation started in background...", vim.log.levels.INFO)

        vim.system({ 'cargo', 'build', '--release' }, {
          cwd = path
        }, function(obj)
          -- This callback runs when the process finishes
          vim.schedule(function()
            if obj.code == 0 then
              vim.notify("Fuzzy success installed", vim.log.levels.INFO)
            else
              vim.notify("Failed to install Fuzzy", vim.log.levels.ERROR)
              -- Print error details to :messages if needed
              if obj.stderr and obj.stderr ~= "" then
                print(obj.stderr)
              end
            end
          end)
        end)
      end
    }
  },
})

-- Lazy load on first insert mode entry (may not necessary)
local group = vim.api.nvim_create_augroup("BlinkCmpLazyLoad", { clear = true })

vim.api.nvim_create_autocmd("InsertEnter", {
  pattern = "*",
  group = group,
  once = true,
  callback = function()
    require("blink.cmp").setup({
      keymap = { preset = "super-tab" },
      appearance = {
        nerd_font_variant = "mono",
        use_nvim_cmp_as_default = true,
      },
      completion = {
        documentation = { auto_show = false },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        per_filetype = {
          -- sql = { 'dadbod' },
          -- optionally inherit from the `default` sources
          lua = { inherit_defaults = true, 'lazydev' }
        },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            -- make lazydev completions top priority (see `:h blink.cmp`)
            score_offset = 100,
          },
        },
      },
      fuzzy = { implementation = "prefer_rust_with_warning" },
    })
  end,
})


-- vim.api.nvim_create_autocmd('PackChanged', {
--   desc = "Handle Fuzzy installation for Blink.cmp",
--   group = vim.api.nvim_create_augroup("blink-pack-changed-update-handler", { clear = true }),
--   callback = function(ev)
--     local name, kind, path = ev.data.spec.name, ev.data.kind, ev.data.path
--     if name == 'blink.cmp' and (kind == 'install' or kind == 'update') then
--       -- local blink_path = vim.fs.joinpath(vim.fn.stdpath('data'), 'site', 'pack', 'core', 'opt', 'blink.cmp')
--
--       -- Notify start
--       vim.notify("Fuzzy installation started in background...", vim.log.levels.INFO)
--
--       vim.system({ 'cargo', 'build', '--release' }, {
--         cwd = path
--       }, function(obj)
--         -- This callback runs when the process finishes
--         vim.schedule(function()
--           if obj.code == 0 then
--             vim.notify("Fuzzy success installed", vim.log.levels.INFO)
--           else
--             vim.notify("Failed to install Fuzzy", vim.log.levels.ERROR)
--             -- Print error details to :messages if needed
--             if obj.stderr and obj.stderr ~= "" then
--               print(obj.stderr)
--             end
--           end
--         end)
--       end)
--     end
--   end
-- })
