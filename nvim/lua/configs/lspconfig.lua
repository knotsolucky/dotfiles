local cap = vim.tbl_deep_extend(
  "force",
  vim.lsp.protocol.make_client_capabilities(),
  require("cmp_nvim_lsp").default_capabilities()
)

local function on_attach(client, bufnr)
  if client.name == "tailwindcss" then pcall(function() require("tailwindcss-colors").buf_attach(bufnr) end) end
  local m, o = vim.keymap.set, { buffer = bufnr }
  local e = function(desc) return vim.tbl_extend("force", o, { desc = desc }) end
  m("n", "gd", vim.lsp.buf.definition, e("Go to definition"))
  m("n", "gD", vim.lsp.buf.declaration, e("Go to declaration"))
  m("n", "gr", vim.lsp.buf.references, e("References"))
  m("n", "K", vim.lsp.buf.hover, e("Hover"))
  m("n", "<leader>ca", vim.lsp.buf.code_action, e("Code action"))
  m("n", "<leader>cf", function() require("conform").format({ async = true, lsp_fallback = true }) end, e("Format"))
  m("n", "[d", vim.diagnostic.goto_prev, e("Prev diagnostic"))
  m("n", "]d", vim.diagnostic.goto_next, e("Next diagnostic"))
end

return {
  capabilities = cap,
  on_attach = on_attach,
  servers = { "lua_ls", "rust_analyzer", "ts_ls", "pyright", "clangd", "jdtls", "jsonls", "cssls", "html", "bashls", "tailwindcss" },
}
