return function(capabilities)
  capabilities.textDocument.completion.completionItem.snippetSupport = true

  return {
      capabilities = capabilities,
      filetypes = { 'html', 'typescriptreact', 'javascriptreact', 'css', 'sass', 'scss', 'less', 'astro', 'php' },
  }
end

