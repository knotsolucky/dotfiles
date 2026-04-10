return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre", "BufNewFile", "BufReadPost" },
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = { "n", "v" },
        desc = "Format buffer (conform / LSP)",
      },
    },
    opts = {
      format_on_save = false,
      formatters_by_ft = {
        lua = { "stylua" },
        javascript = { "prettier", "prettierd", stop_after_first = true },
        javascriptreact = { "prettier", "prettierd", stop_after_first = true },
        typescript = { "prettier", "prettierd", stop_after_first = true },
        typescriptreact = { "prettier", "prettierd", stop_after_first = true },
        json = { "prettier", "prettierd", stop_after_first = true },
        markdown = { "prettier", "prettierd", stop_after_first = true },
      },
    },
  },
}
