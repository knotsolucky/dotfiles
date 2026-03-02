return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = { "hrsh7th/cmp-nvim-lsp", "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim" },
  },
  { "williamboman/mason.nvim", lazy = false, build = ":MasonUpdate", opts = {} },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    config = function()
      local cap = vim.tbl_deep_extend(
        "force",
        vim.lsp.protocol.make_client_capabilities(),
        require("cmp_nvim_lsp").default_capabilities()
      )
      local function on_attach(_, bufnr)
        local m, o = vim.keymap.set, { buffer = bufnr }
        m("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", o, { desc = "Go to definition" }))
        m("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", o, { desc = "Go to declaration" }))
        m("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", o, { desc = "References" }))
        m("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", o, { desc = "Hover" }))
        m("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", o, { desc = "Code action" }))
        m("n", "<leader>cf", function()
          require("conform").format({ async = true, lsp_fallback = true })
        end, vim.tbl_extend("force", o, { desc = "Format" }))
      end
      local servers = {
        "lua_ls",
        "ts_ls",
        "pyright",
        "jsonls",
        "cssls",
        "tailwindcss",
        "rust_analyzer",
        "clangd",
        "jdtls",
        "zls",
      }
      require("mason-lspconfig").setup({
        automatic_installation = true,
        ensure_installed = servers,
        handlers = {
          function(server)
            require("lspconfig")[server].setup({
              capabilities = cap,
              on_attach = on_attach,
            })
          end,
        },
      })
    end,
  },
}
