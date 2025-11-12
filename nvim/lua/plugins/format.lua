return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    opts = {
      notify_on_error = false,
      formatters_by_ft = {
        lua = { "stylua" },
        javascript = { "eslint_d", "prettierd", "prettier" },
        typescript = { "eslint_d", "prettierd", "prettier" },
        javascriptreact = { "eslint_d", "prettierd", "prettier" },
        typescriptreact = { "eslint_d", "prettierd", "prettier" },
        json = { "prettierd", "prettier" },
        html = { "prettierd", "prettier" },
        css = { "prettierd", "prettier" },
        markdown = { "prettierd", "prettier" },
        python = { "black" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        yaml = { "yamlfmt" },
        c = { "clang_format" },
        cpp = { "clang_format" },
        cs = { "csharpier" },
        java = { "google-java-format" },
      },
      format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
      formatters = {
        csharpier = {
          command = (vim.env.MASON or (vim.fn.stdpath("data") .. "/mason")) .. "/bin/csharpier",
          args = { "--write-stdout" },
          stdin = true,
        },
      },
    },
  },
}
