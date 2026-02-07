local cap = vim.tbl_deep_extend(
  "force",
  vim.lsp.protocol.make_client_capabilities(),
  require("cmp_nvim_lsp").default_capabilities()
)

local function on_attach(_, bufnr)
  local m = vim.keymap.set
  local o = { buffer = bufnr }
  m("n", "gd", vim.lsp.buf.definition, o)
  m("n", "gD", vim.lsp.buf.declaration, o)
  m("n", "gr", vim.lsp.buf.references, o)
  m("n", "K", vim.lsp.buf.hover, o)
  m("n", "<leader>ca", vim.lsp.buf.code_action, o)
  m("n", "<leader>cf", function()
    require("conform").format({ async = true, lsp_fallback = true })
  end, o)
  m("n", "[d", vim.diagnostic.goto_prev, o)
  m("n", "]d", vim.diagnostic.goto_next, o)
end

return {
  capabilities = cap,
  on_attach = on_attach,
  servers = { "lua_ls", "ts_ls", "pyright", "jsonls", "cssls" },
}
