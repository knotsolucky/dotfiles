return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = { "hrsh7th/cmp-nvim-lsp", "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim" },
    config = function() require("configs.lspconfig") end,
  },
  { "williamboman/mason.nvim", lazy = false, build = ":MasonUpdate", opts = {} },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    config = function()
      local lsp = require("configs.lspconfig")
      require("mason-lspconfig").setup({
        automatic_installation = true,
        ensure_installed = lsp.servers,
        handlers = {
          function(server)
            require("lspconfig")[server].setup({
              capabilities = lsp.capabilities,
              on_attach = lsp.on_attach,
            })
          end,
        },
      })
    end,
  },
}
