return function()
  return {
    commands = {
      Format = {
        function()
          require('stylua-nvim').format_file()
        end,
      },
    },

    settings = {
      Lua = {
        completion = {
          callSnippet = 'Replace',
        },
      workspace = {
        checkThirdParty = false, -- Disabled third party's work environment
      },
      },
    },
  }
end
