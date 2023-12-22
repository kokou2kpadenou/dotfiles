--https://github.com/roobert/tailwindcss-colorizer-cmp.nvim we add color
--
local coloriser = {}

local fnc = require 'colorizer-cmp.util'

function coloriser.color_formater()
  return function(entry, vim_item)
    if vim_item.kind == 'Color' then
      local bg, fg

      bg, fg = fnc.colorBgFg(entry.completion_item.documentation)

      if not bg then
        bg, fg = fnc.colorBgFg(vim_item.abbr)
      end

      if bg then
        local group = 'lsp_documentColor_cmp_' .. string.sub(bg, 2)

        local hl_opts = { fg = fg, bg = bg }

        vim.api.nvim_set_hl(0, group, hl_opts)
        vim_item.kind_hl_group = group
      end
    end
  end
end

return coloriser
