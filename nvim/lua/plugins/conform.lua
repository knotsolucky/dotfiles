return {
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = function()
      local lsp = require("configs.lspconfig")
      return {
        format_on_save = { timeout_ms = 500, lsp_fallback = true },
        formatters_by_ft = lsp.formatters_by_ft,
      }
    end,
    config = function(_, opts) require("conform").setup(opts) end,
  },
}
