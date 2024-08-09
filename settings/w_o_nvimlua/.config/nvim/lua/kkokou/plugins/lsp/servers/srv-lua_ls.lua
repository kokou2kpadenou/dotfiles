return function()
  return {
    settings = {
      Lua = {
        completion = {
          callSnippet = 'Replace',
        },
        workspace = {
          checkThirdParty = false, -- Disabled third party's work environment
        },
        telemetry = { enable = false },
        hint = { enable = true },
      },
    },
  }
end
