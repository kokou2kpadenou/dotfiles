return function(capabilities)
  capabilities.textDocument.completion.completionItem.snippetSupport = true

  return {
    settings = {
      evenBetterToml = {
        schema = {
          -- add additional schemas
          associations = {
            ['example\\.toml$'] = 'https://json.schemastore.org/example.json',
          },
        },
      },
      -- yaml = {
      --   -- Schemas https://www.schemastore.org
      --   schemas = {
      --     {
      --       fileMatch = { 'docker-compose.yml' },
      --       url = 'https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json',
      --     },
      --   },
      -- },
    },
  }
end
