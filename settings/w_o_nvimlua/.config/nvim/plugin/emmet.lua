-- emmet-vim

local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local g = vim.g      -- a table to access global variables

cmd [[autocmd FileType html,css,javascript,javascriptreact EmmetInstall]]

g.user_emmet_install_global = 0
g.user_emmet_leader_key = ","
g.user_emmet_settings = {
    javascript = {
        extends = "jsx"
    }
}
