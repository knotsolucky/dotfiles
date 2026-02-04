require("nvchad.configs.lspconfig").defaults()

local servers = {
  "html",
  "cssls",
  "tsserver",
  "pyright",
  "jsonls",
  "bashls",
  "yamlls",
  "clangd",
  "tailwindcss",
  "csharp_ls",
  "rust_analyzer",
  "jdtls",
}
vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers 
