return function(capabilities)
  capabilities.textDocument.completion.completionItem.snippetSupport = true

  return {
    settings = {
      capabilities = capabilities,
      filetypes = { 'html', 'typescriptreact', 'javascriptreact', 'css', 'sass', 'scss', 'less', 'astro' },
    },
  }
end

