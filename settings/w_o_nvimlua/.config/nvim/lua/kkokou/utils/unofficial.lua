local M = {}

function M.is_floating(win_id)
  local cfg = vim.api.nvim_win_get_config(win_id)
  if cfg.relative > '' or cfg.external then
    return true
  end
  return false
end

function M.detect_win_split()
  local wc = 0
  local windows = vim.api.nvim_tabpage_list_wins(0)

  for _, v in pairs(windows) do
    if not M.is_floating(v) then
      wc = wc + 1
    end
  end

  return wc > 1
end

function M.has_value(tab, val)
  for _, value in ipairs(tab) do
    if value == val then
      return true
    end
  end
end

function M.start_with(pattern, target)
  local partten_len = #pattern
  local target_first_mean = string.sub(target, 1, partten_len)
  return target_first_mean == pattern
end

function M.getNextColor(colors, color)
  local index = 1

  for i = 1, #colors do
    if M.start_with(colors[i], color) then
      index = i
      break
    end
  end

  return colors[(index % #colors) + 1]
end

function M.removeElementFromTable(tabl, element)
    for i = 1, #tabl do
        if tabl[i] == element then
            table.remove(tabl, i)
            return tabl  -- Return the updated table after removing the element.
        end
    end
    return tabl  -- If the element was not found, return the original table.
end

return M
