-- NOTE: base https://github.com/roobert/tailwindcss-colorizer-cmp.nvim we add color
--
--
--TODO: Enable alpha
--
local coloriser = {}

local fnc = require 'colorizer-cmp.util'

function coloriser.color_formater(opts)
  if opts == nil then
    opts = {}
  end

  -- local dft_opts = {
  --   enable_alpha = false,
  -- }

  -- local config = vim.tbl_deep_extend('force', dft_opts, opts)

  return function(entry, vim_item)
    if vim_item.kind == 'Color' then
      local bg, fg
      -- if entry.completion_item.documentation then
      bg, fg = fnc.colorBgFg(entry.completion_item.documentation)

      if not bg then
        bg, fg = fnc.colorBgFg(vim_item.abbr)
      end

      -- print('Cool', bg)
      if bg then
        local group = 'lsp_documentColor_cmp_' .. string.sub(bg, 2)

        -- if vim.fn.hlID(group) == 0 then
        -- if vim.fn.hlexists(group) == 0 then
        local hl_opts = { fg = fg, bg = bg }

        --[[ if config.enable_alpha then
            -- hl_opts.blend = 100 - (0.4 * 100)
            hl_opts.blend = 10
          end ]]

        vim.api.nvim_set_hl(0, group, hl_opts)
        -- end
        vim_item.kind_hl_group = group
      end
    end
  end
end

return coloriser
