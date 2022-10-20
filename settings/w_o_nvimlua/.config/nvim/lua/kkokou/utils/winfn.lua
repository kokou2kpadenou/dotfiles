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



return M
