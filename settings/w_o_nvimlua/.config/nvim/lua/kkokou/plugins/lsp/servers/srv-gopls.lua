return function()
  return {
    settings = {
      gopls = {
        usePlaceholders = true,
        analyses = {
          unusedparams = true,
        },
        staticcheck = true,
      },
    },
  }
end
