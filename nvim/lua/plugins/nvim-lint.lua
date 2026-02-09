return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      linters_by_ft = {
        javascript = {},
        javascriptreact = {},
        typescript = {},
        typescriptreact = {},
        c = { "clang_tidy" },
        cpp = { "clang_tidy" },
        python = { "ruff" },
        java = {},
      },
    },
    config = function(_, opts)
      require("lint").linters_by_ft = opts.linters_by_ft
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
        callback = function() pcall(require("lint").try_lint) end,
      })
    end,
  },
}
