return function(capabilities)
  capabilities.textDocument.completion.completionItem.snippetSupport = true

  return {
      capabilities = capabilities,
      filetypes = { 'html', 'typescriptreact', 'javascriptreact', 'css', 'sass', 'scss', 'less', 'astro', 'php', 'gotmpl' },
      init_options = {
        html = {
          options = {
            -- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
            ["bem.enabled"] = true,
          },
        },
      }
  }
end

