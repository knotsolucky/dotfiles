local cap = vim.tbl_deep_extend(
  "force",
  vim.lsp.protocol.make_client_capabilities(),
  require("cmp_nvim_lsp").default_capabilities()
)

local function on_attach(_, bufnr)
  local m = vim.keymap.set
  local o = { buffer = bufnr }
  m("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", o, { desc = "Go to definition" }))
  m("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", o, { desc = "Go to declaration" }))
  m("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", o, { desc = "References" }))
  m("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", o, { desc = "Hover" }))
  m("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", o, { desc = "Code action" }))
  m("n", "<leader>cf", function()
    require("conform").format({ async = true, lsp_fallback = true })
  end, vim.tbl_extend("force", o, { desc = "Format" }))
  m("n", "[d", vim.diagnostic.goto_prev, vim.tbl_extend("force", o, { desc = "Previous diagnostic" }))
  m("n", "]d", vim.diagnostic.goto_next, vim.tbl_extend("force", o, { desc = "Next diagnostic" }))
end

return {
  capabilities = cap,
  on_attach = on_attach,
  servers = { "lua_ls", "ts_ls", "pyright", "jsonls", "cssls" },
}
