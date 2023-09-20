local util = require 'lspconfig.util'

local function get_typescript_server_path(root_dir)
  -- TODO: Rewrite this with npm case and pnpm case
  local project_root = util.find_node_modules_ancestor(root_dir)
  -- location of 'tsserverlibrary.js' from root directory
  local new_tsdk = vim.fs.find('tsserverlibrary.js', {
    path = project_root,
  })

  return #new_tsdk == 0 and '' or vim.fs.dirname(new_tsdk[1])
end

return function()
  return {
    -- {
    -- init_options = {
    --   configuration = {},
    --   typescript = {
    --     tsdk = vim.fs.normalize '~/.local/share/pnpm/global/5/node_modules/typescript/lib',
    --   },
    -- },
    on_new_config = function(new_config, new_root_dir)
      if
          vim.tbl_get(new_config.init_options, 'typescript') --[[ and not new_config.init_options.typescript.tsdk ]]
      then
        new_config.init_options.typescript.tsdk = get_typescript_server_path(new_root_dir)
        -- print(get_typescript_server_path(new_root_dir))
      end
    end,
  }
  -- }
end
